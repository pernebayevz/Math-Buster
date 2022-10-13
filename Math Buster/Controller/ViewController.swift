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
        countDown = 30
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
            timer?.invalidate()
            resultField.isEnabled = false
            submitButton.isEnabled = false
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
}

