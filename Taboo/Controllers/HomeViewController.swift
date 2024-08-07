//
//  HomeViewController.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hardmode: UISwitch!
    @IBOutlet weak var team1: UITextField!
    @IBOutlet weak var team2: UITextField!
    @IBOutlet weak var team3: UITextField!
    @IBOutlet weak var team4: UITextField!
    @IBOutlet weak var cards: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var penalty: UITextField!
    
    @IBAction func play(_ sender: Any) {
        
        var teamsText: [String] = []
        if (!team1.text!.isEmpty) {
            teamsText.append(team1.text!)
        }
        if (!team2.text!.isEmpty) {
            teamsText.append(team2.text!)
        }
        if (!team3.text!.isEmpty) {
            teamsText.append(team3.text!)
        }
        if (!team4.text!.isEmpty) {
            teamsText.append(team4.text!)
        }
        
        let nbCards = Int(cards.text!)!;
        let nbDuration = Int(duration.text!)!;
        let nbPass = Int(pass.text!)!;
        let nbPenalty = Int(penalty.text!)!;
        
        if (teamsText.count < 2 || cards.text!.isEmpty || duration.text!.isEmpty || pass.text!.isEmpty || penalty.text!.isEmpty) {
            return
        }
        
        if (nbCards > 56 || nbCards < 1 || nbDuration < 1 || nbPass < 0 || nbPenalty < 0) {
            return
        }
        
        TabooManager.shared.setupGame(isHard: hardmode.isOn, teams: teamsText, numberOfCards: Int(cards.text!)!, turnDuration: Int(duration.text!)!, numberOfPass: Int(pass.text!)!, errorPenalty: Int(penalty.text!)!)
        
        performSegue(withIdentifier: "segueHomeToPlay", sender: self)
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        team1.delegate = self
        team2.delegate = self
        team3.delegate = self
        team4.delegate = self
        cards.delegate = self
        duration.delegate = self
        pass.delegate = self
        penalty.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case team1:
            team2.becomeFirstResponder()
            break
        case team2:
            team3.becomeFirstResponder()
            break
        case team3:
            team4.becomeFirstResponder()
            break
        case team4:
            cards.becomeFirstResponder()
            break
        case cards:
            duration.becomeFirstResponder()
            break
        case duration:
            pass.becomeFirstResponder()
            break
        case pass:
            penalty.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
