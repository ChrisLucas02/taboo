//
//  TabooManager.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation
import UIKit

class TabooManager {
    
    let DEFAULT_DIFFICULTY = true
    let DEFAULT_NUMBER_OF_CARDS = 30
    let MAX_NUMBER_OF_CARDS = 56
    let DEFAULT_TURN_DURATION = 45
    let DEFAULT_NUMBER_OF_PASS = 2
    let DEFAULT_ERROR_PENALTY = 5
    
    var numberOfCards: Int!
    var turnDuration: Int!
    var numberOfPass: Int!
    var errorPenalty: Int!
    var cards: [Taboo]!
    var playedThisRound: [Taboo]!
    var played: [Taboo]!
    
    var teams: [Team]!
    var successes: Int!
    var failures: Int!
    var availablePass: Int!
    var currentTeam: Int!
    var currentCard: Taboo!
    var timer: Timer!
    var isPlaying: Bool!
    var gameOver: Bool!
    
    var remainingTime: Int!
    
    static let shared = TabooManager()
    
    var delegate: TabooManagerDelegate?
    
    func setupGame(isHard: Bool, teams: [String], numberOfCards: Int, turnDuration: Int, numberOfPass: Int, errorPenalty: Int) {
        
        if (numberOfCards < 1 || numberOfCards > MAX_NUMBER_OF_CARDS) {
            self.numberOfCards = DEFAULT_NUMBER_OF_CARDS;
        } else {
            self.numberOfCards = numberOfCards;
        }

        if (turnDuration < 1) {
            self.turnDuration = DEFAULT_TURN_DURATION;
        } else {
            self.turnDuration = turnDuration;
        }

        if (numberOfPass < 0) {
            self.numberOfPass = DEFAULT_NUMBER_OF_PASS;
        } else {
            self.numberOfPass = numberOfPass;
        }
            
        if (errorPenalty < 0) {
            self.errorPenalty = DEFAULT_ERROR_PENALTY;
        } else {
            self.errorPenalty = errorPenalty;
        }
            
        self.teams = []
        for name in teams {
            self.teams.append(Team(name: name))
        }
        
        successes = 0;
        failures = 0;
        availablePass = numberOfPass;
        currentTeam = 0;
        isPlaying = false;
        playedThisRound = [];
        played = [];
        gameOver = false;
        remainingTime = turnDuration;
        
        loadTaboos(isHard: isHard)
    }
    
    func startTurn() {
        if (!isPlaying) {
            newCard()
            isPlaying = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerTick), userInfo: nil, repeats: true)
        }
    }
    
    func validateTurn() {
        let team = teams[currentTeam]
        while (!playedThisRound.isEmpty) {
            let card = playedThisRound.remove(at: 0)
            if (card.state == CardState.won) {
                team.incrementScore()
                played.append(card)
            } else {
                card.state = .passed
                cards.append(card)
            }
        }
        
        if (played.count < numberOfCards) {
            nextTurn()
            startTurn()
        } else {
            teams.sort(by: {$0.score > $1.score})
            gameOver = true
        }
    }
    
    func success() {
        if (isPlaying) {
            successes += 1
            currentCard.state = .won
            newCard()
        }
    }
    
    func failure() {
        if (isPlaying) {
            failures += 1
            currentCard.state = .failed
            decrementTimer(value: errorPenalty)
            newCard()
        }
    }
    
    func pass() {
        if (isPlaying) {
            availablePass -= 1
            if (availablePass < 0) {
                availablePass = 0
            } else {
                currentCard.state = .passed
                newCard()
            }
        }
    }
    
    func getCurrentTeam() -> String {
        return teams[currentTeam].name
    }
    
    func getNumberOfRemainingCards() -> Int {
        return cards.count
    }
    
    private func newCard() {
        if (cards.count != 0) {
            currentCard = cards.remove(at: 0)
            playedThisRound.append(currentCard)
        } else if (isPlaying) {
            timer.invalidate()
            isPlaying = false
            delegate?.onTurnFinished()
        }
    }
    
    private func nextTurn() {
        currentTeam += 1
        currentTeam %= teams.count
        availablePass = numberOfPass
        successes = 0
        failures = 0
        remainingTime = turnDuration;
    }
    
    private func loadTaboos(isHard: Bool) {
        var asset: NSDataAsset!
        if (isHard) {
            asset = NSDataAsset(name: "TabooCardsHard", bundle: Bundle.main)
        } else {
            asset = NSDataAsset(name: "TabooCardsHard", bundle: Bundle.main)
        }

        cards = []
        
        do {
            let json = try JSONSerialization.jsonObject(with: asset!.data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            for index in 0..<numberOfCards {
                let t = json[index] as! NSDictionary
                let word = t.value(forKey: "word") as! String
                let taboos = t.value(forKey: "taboos") as! [String]
                cards.append(Taboo(word: word, taboos: taboos))
            }
        } catch {
            
        }
    }
    
    @IBAction private func onTimerTick() {
        decrementTimer(value: 1)
    }
    
    private func decrementTimer(value: Int) {
        remainingTime -= value
        if (remainingTime <= 0) {
            timer.invalidate()
            isPlaying = false
            delegate?.onTurnFinished()
        } else {
            let progress = Float(remainingTime) / Float(turnDuration)
            delegate?.onTick(remainingTime: remainingTime, progress: progress)
        }
    }
}

protocol TabooManagerDelegate {
    func onTick(remainingTime: Int, progress: Float)
    func onTurnFinished()
}
