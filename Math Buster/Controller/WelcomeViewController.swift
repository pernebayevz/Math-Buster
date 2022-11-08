//
//  WelcomeViewController.swift
//  Math Buster
//
//  Created by Zhangali Pernebayev on 03.11.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
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
        tableView.delegate = self
//        tableView.rowHeight = 60
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.addTarget(self, action: #selector(getUserScore), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        getUserScore()
    }

    @objc
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
        
        tableView.refreshControl?.endRefreshing()
        self.userScoreArrayOfDictionaries = userScoreArrayOfDictionaries
    }
    
    func getSingleUserText(index: Int) -> String? {
        let dictionary: [String: Any] = userScoreArrayOfDictionaries[index]
        guard let name = dictionary["name"] as? String, let score = dictionary["score"] as? Int else {
            return nil
        }
        let text = "Name: \(name), Score: \(score)"
        return text
    }
}

//MARK: UITableViewDatasource & UITableViewDelegate
extension WelcomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userScoreArrayOfDictionaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        cell.scoreTextLabel.text = getSingleUserText(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ScoreDetailViewController()
        viewController.text = getSingleUserText(index: indexPath.row)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
