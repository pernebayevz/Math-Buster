//
//  ViewController.swift
//  Math Buster
//
//  Created by Zhangali Pernebayev on 13.10.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var resultField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var timer: Timer?
    var countDown: Int = 30
    var result: Double?
    var score: Int = 0
    var ranges = [0...9, 10...99, 100...999]
    var scoreAmount = [1, 2, 3]
    
    var navigationBarPreviousTintColor: UIColor?
    
    static let userScoreKey: String = "userScore"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        generateProblem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBarPreviousTintColor = navigationController?.navigationBar.tintColor
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scheduleTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = navigationBarPreviousTintColor
    }

    func setupUI() {
//        navigationItem.title = "New Title"
        timerContainerView.layer.cornerRadius = 5
        resultField.keyboardType = .decimalPad
    }
    
    func generateProblem() {
        
        let selectedIndex: Int = segmentedControl.selectedSegmentIndex
        let range = ranges[selectedIndex]
        
        let firstDigit = Int.random(in: range)
        let arithmeticOperator: String = ["+", "-", "x", "/"].randomElement()!
        
        var startingInteger: Int = range.lowerBound
        var endingInteger: Int = range.upperBound
        
        if arithmeticOperator == "/" && startingInteger == 0 {
            startingInteger = 1
        }else if arithmeticOperator == "-" {
            endingInteger = firstDigit
        }
        
        let secondDigit = Int.random(in: startingInteger...endingInteger)
        
        problemLabel.text = "\(firstDigit) \(arithmeticOperator) \(secondDigit) ="
        
        switch arithmeticOperator {
        case "+":
            result = Double(firstDigit + secondDigit)
        case "-":
            result = Double(firstDigit - secondDigit)
        case "x":
            result = Double(firstDigit * secondDigit)
        case "/":
            result = Double(firstDigit) / Double(secondDigit)
        default:
            result = nil
        }
    }
    
    func scheduleTimer() {
        countDown = 2
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerUI), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateTimerUI() {
        countDown -= 1
        
        let seconds: String = String(format: "%02d", countDown)
        
//        if countDown < 10 {
//            seconds = "0\(countDown)"
//        }
        
        timerLabel.text = "00 : \(seconds)"
        progressView.progress = Float(30 - countDown) / 30
        print("progressView.progress: \(progressView.progress)")
        
        if countDown <= 0 {
            finishTheGame()
        }
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        guard let text = resultField.text else {
            print("Text is nil")
            return
        }
        guard !text.isEmpty else {
            print("Text is empty")
            return
        }
        guard let newResult = Double(text) else {
            print("Couldn't convert text: \(text) to Double")
            return
        }
        
        if newResult == result {
            print("Correct answer!")
            let selectedIndex = segmentedControl.selectedSegmentIndex
            score += scoreAmount[selectedIndex]
            scoreLabel.text = "Score: \(score)"
        }else{
            print("Incorrect answer!")
        }
        
        generateProblem()
        resultField.text = nil
    }
    
    @IBAction func restartPressed(_ sender: Any) {
        restart()
    }
    
    func restart() {
        score = 0
        scoreLabel.text = "Score: 0"
        
        generateProblem()
        
        scheduleTimer()
        
        resultField.isEnabled = true
        submitButton.isEnabled = true
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        restart()
    }
    
    func finishTheGame() {
        timer?.invalidate()
        resultField.isEnabled = false
        submitButton.isEnabled = false
        
        askForName()
    }
    
    func askForName() {
        let alertController = UIAlertController(title: "Game is Over!", message: "Save your score: \(score)", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter your name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alertController.textFields?.first else {
                print("Textfield is absent")
                return
            }
            guard let text = textField.text, !text.isEmpty else {
                print("Text is nil or empty")
                return
            }
            print("Name: \(text)")
            
            //TO DO: Save user score record permanently on device
            self.saveUserScore(name: text)
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
//        let skipAction = UIAlertAction(title: "Skip", style: .destructive)
//        alertController.addAction(skipAction)
        
        present(alertController, animated: true)
    }
    
    func saveUserScore(name: String) {
        let userScore: [String: Any] = ["name": name, "score": score]
        let userScoreArray: [[String: Any]] = getUserScoreArray() + [userScore]
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userScoreArray, forKey: ViewController.userScoreKey)
    }
    
    func getUserScoreArray() -> [[String: Any]] {
        let userDefaults = UserDefaults.standard
        let array = userDefaults.array(forKey: ViewController.userScoreKey) as? [[String: Any]]
        return array ?? []
    }
}

