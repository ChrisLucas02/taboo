//
//  EndViewController.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet weak var teamGold: UILabel!
    @IBOutlet weak var scoreGold: UILabel!
    @IBOutlet weak var teamSilver: UILabel!
    @IBOutlet weak var scoreSilver: UILabel!
    @IBOutlet weak var teamBronze: UILabel!
    @IBOutlet weak var scoreBronze: UILabel!
    @IBOutlet weak var teamFail: UILabel!
    @IBOutlet weak var scoreFail: UILabel!
    @IBOutlet weak var layoutBronze: UIStackView!
    @IBOutlet weak var layoutFail: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCustomBackButton()
        
        let teams = TabooManager.shared.teams!

        teamGold.text = "Team: " + teams[0].name
        scoreGold.text = String(teams[0].score)
        
        teamSilver.text = "Team: " + teams[1].name
        scoreSilver.text = String(teams[1].score)
        
        if (teams.count >= 3) {
            layoutBronze.isHidden = false
            teamBronze.text = "Team: " + teams[2].name
            scoreBronze.text = String(teams[2].score)
        }
        
        if (teams.count >= 4) {
            layoutFail.isHidden = false
            teamFail.text = "Team: " + teams[3].name
            scoreFail.text = String(teams[3].score)
        }
    }
    
    private func showCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = getCustomBackButton(title: "Taboo")
        backButton.addTarget(self, action: #selector(self.onBackPressed(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction private func onBackPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindEndToHome", sender: self)
    }
    
}
