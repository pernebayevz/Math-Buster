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
    
    var timer: Timer?
    var countDown: Int = 30
    var result: Double?
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        generateProblem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scheduleTimer()
    }

    func setupUI() {
        timerContainerView.layer.cornerRadius = 5
        resultField.keyboardType = .default
    }
    
    func generateProblem() {
        let firstDigit = Int.random(in: 0...9)
        let secondDigit = Int.random(in: 0...9)
        let arithmeticOperator: String = ["+", "-", "x", "/"].randomElement()!
        
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
        
        timerLabel.text = "00 : \(countDown)"
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
            score += 1
            scoreLabel.text = "Score: \(score)"
        }else{
            print("Incorrect answer!")
        }
        
        generateProblem()
        resultField.text = nil
    }
    
    @IBAction func restartPressed(_ sender: Any) {
        score = 0
        scoreLabel.text = "Score: 0"
        
        generateProblem()
        
        scheduleTimer()
        
        resultField.isEnabled = true
        submitButton.isEnabled = true
    }
    
}

