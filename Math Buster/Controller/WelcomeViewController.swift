//
//  WelcomeViewController.swift
//  Math Buster
//
//  Created by Zhangali Pernebayev on 03.11.2022.
//

import UIKit

class WelcomeViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userScoreArrayOfDictionaries: [[String: Any]] = [] {
        didSet {
            print("Value of variable 'userScoreArrayOfDictionaries' was changed")
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "ScoreTableViewCell", bundle: nil), forCellReuseIdentifier: ScoreTableViewCell.identifier)
        tableView.dataSource = self
//        tableView.rowHeight = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getUserScore()
    }

    func getUserScore() {
        let userDefaults = UserDefaults.standard
        
        guard let userScore = userDefaults.array(forKey: ViewController.userScoreKey) else {
            print("Userdefaults doesn't contain array with key : \(ViewController.userScoreKey)")
            return
        }
        guard let userScoreArrayOfDictionaries = userScore as? [[String: Any]] else {
            print("Couldn't convert Any to [[String: Any]]")
            return
        }
        
        self.userScoreArrayOfDictionaries = userScoreArrayOfDictionaries
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScoreArrayOfDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        
        let dictionary: [String: Any] = userScoreArrayOfDictionaries[indexPath.row]
        if let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int {
            cell.scoreTextLabel.text = "Name: \(name), Score: \(score)"
        }
        
        return cell
    }
}
