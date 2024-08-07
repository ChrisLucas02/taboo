//
//  ConfirmViewController.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit
import os;

class ConfirmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tabooManager = TabooManager.shared
    var passesAllowed = 0;
    
    @IBOutlet weak var answerTable: UITableView!
    
    @IBAction func validate(_ sender: Any) {
        tabooManager.validateTurn()
        if (tabooManager.gameOver) {
            performSegue(withIdentifier: "segueConfirmToEnd", sender: self)
        } else {
            performSegue(withIdentifier: "unwindToPlay", sender: self)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCustomBackButton()
        answerTable.delegate = self;
        answerTable.dataSource = self;
        answerTable.reloadData();
        passesAllowed = tabooManager.availablePass;
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    private func showCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = getCustomBackButton(title: "Taboo")
        backButton.addTarget(self, action: #selector(self.onBackPressed(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabooManager.playedThisRound.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomTableViewCell;
        
        let txt = tabooManager.playedThisRound[indexPath.row].word;
        cell.lblCell.text = txt;
        
        switch tabooManager.playedThisRound[indexPath.row].state {
        case CardState.won:
            cell.imgCell.image = UIImage(named:"correct");
        case CardState.passed:
            cell.imgCell.image = UIImage(named:"passed");
        case CardState.failed:
            cell.imgCell.image = UIImage(named:"wrong");
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell;
        let taboo2Change = tabooManager.playedThisRound[indexPath.row];

        switch taboo2Change.state {
        case CardState.won:
            if (passesAllowed > 0) {
                taboo2Change.state = CardState.passed;
                cell.imgCell.image = UIImage(named:"passed");
                passesAllowed = passesAllowed - 1;
            } else {
                taboo2Change.state = CardState.failed;
                cell.imgCell.image = UIImage(named:"wrong");
            }
        case CardState.passed:
            if (taboo2Change.state != CardState.won) {
                passesAllowed = passesAllowed + 1;
            }
            taboo2Change.state = CardState.failed;
            cell.imgCell.image = UIImage(named:"wrong");
        case CardState.failed:
            taboo2Change.state = CardState.won;
            cell.imgCell.image = UIImage(named:"correct");
            
        }
    }
    
}
