//
//  WelcomeViewController.swift
//  Math Buster
//
//  Created by Zhangali Pernebayev on 03.11.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [UserScoreSection] = [] {
        didSet {
            print("Value of variable 'dataSource' was changed")
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
        tableView.refreshControl?.endRefreshing()
        
        let easyScoreList = ViewController.getAllUserScores(level: .easy)
        let easySection = UserScoreSection(list: easyScoreList, title: "Easy")
        
        let mediumScoreList = ViewController.getAllUserScores(level: .medium)
        let mediumSection = UserScoreSection(list: mediumScoreList, title: "Medium")
        
        let hardScoreList = ViewController.getAllUserScores(level: .hard)
        let hardSection = UserScoreSection(list: hardScoreList, title: "Hard")
        
        self.dataSource = [easySection, mediumSection, hardSection]
    }
    
    func getSingleUserText(indexPath: IndexPath) -> String? {
        let userScore: UserScore = dataSource[indexPath.section].list[indexPath.row]
        let text = "Name: \(userScore.name), Score: \(userScore.score)"
        return text
    }
}

//MARK: UITableViewDatasource & UITableViewDelegate
extension WelcomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.identifier, for: indexPath) as! ScoreTableViewCell
        cell.scoreTextLabel.text = getSingleUserText(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let viewController = ScoreDetailViewController()
        viewController.text = getSingleUserText(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
}


struct UserScoreSection {
    let list: [UserScore]
    let title: String
}
