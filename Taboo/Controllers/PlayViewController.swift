//
//  PlayViewController.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController, TabooManagerDelegate {
    
    var tabooManager = TabooManager.shared
    
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var taboo1: UILabel!
    @IBOutlet weak var taboo2: UILabel!
    @IBOutlet weak var taboo3: UILabel!
    @IBOutlet weak var taboo4: UILabel!
    @IBOutlet weak var successes: UILabel!
    @IBOutlet weak var passes: UILabel!
    @IBOutlet weak var errors: UILabel!
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var cards: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    @IBAction func error(_ sender: UIButton) {
        tabooManager.failure()
        updateUI()
    }
    
    @IBAction func pass(_ sender: UIButton) {
        tabooManager.pass()
        updateUI()
    }
    
    @IBAction func correct(_ sender: UIButton) {
        tabooManager.success()
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabooManager.delegate = self
        tabooManager.startTurn()
        
        initUI()
        updateUI()
    }
    
    private func initUI() {
        progress.setProgress(1.0, animated: false)
        time.text = String(tabooManager.turnDuration)
    }

    private func updateUI() {
        team.text = "Team: " + tabooManager.getCurrentTeam()
        cards.text = "Remaining cards: " + String(tabooManager.getNumberOfRemainingCards())
        successes.text = String(tabooManager.successes)
        errors.text = String(tabooManager.failures)
        passes.text = String(tabooManager.availablePass) + "/" + String(tabooManager.numberOfPass)
        
        let card = tabooManager.currentCard
        word.text = card?.word
        taboo1.text = card?.taboos[0]
        taboo2.text = card?.taboos[1]
        taboo3.text = card?.taboos[2]
        taboo4.text = card?.taboos[3]
    }
    
    func onTick(remainingTime: Int, progress: Float) {
        self.progress.setProgress(progress, animated: true)
        time.text = String(remainingTime)
    }
    
    func onTurnFinished() {
        self.progress.setProgress(0.0, animated: true)
        time.text = String(0)
        
        performSegue(withIdentifier: "seguePlayToConfirm", sender: self)
    }
    
    @IBAction func unwindToPlay(_ unwindSegue: UIStoryboardSegue) {
        initUI()
        updateUI()
    }
}
