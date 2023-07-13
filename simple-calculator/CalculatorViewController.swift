//
//  ViewController.swift
//  simple-calculator
//

import UIKit

class CalculatorViewController: UIViewController {
    var isNewValue = true
    var operation: MathOperation? = nil
    var previousOperation: MathOperation? = nil
    var result: Int = 0
    var newValue: Int = 0
    
    @IBAction func onOne(_ sender: Any) {
        addDigit("1")
    }
    @IBAction func onTwo(_ sender: Any) {
        addDigit("2")
    }
    @IBAction func onThree(_ sender: Any) {
        addDigit("3")
    }
    @IBAction func onFour(_ sender: Any) {
        addDigit("4")
    }
    @IBAction func onFive(_ sender: Any) {
        addDigit("5")
    }
    @IBAction func onSix(_ sender: Any) {
        addDigit("6")
    }
    @IBAction func onSeven(_ sender: Any) {
        addDigit("7")
    }
    @IBAction func onEight(_ sender: Any) {
        addDigit("8")
    }
    @IBAction func onNine(_ sender: Any) {
        addDigit("9")
    }
    @IBAction func onZero(_ sender: Any) {
        addDigit("0")
    }
    
    @IBAction func onEqual(_ sender: Any) {
        calculate()
    }
    @IBAction func onPlus(_ sender: Any) {
        operation = .sum
        previousOperation = nil
        isNewValue = true
        result = getInteger()
        resultLabel.text = "+"
    }
    @IBAction func onMinus(_ sender: Any) {
        operation = .minus
        previousOperation = nil
        isNewValue = true
        result = getInteger()
        resultLabel.text = "−"
    }
    @IBAction func onMultiplication(_ sender: Any) {
        operation = .multiplication
        previousOperation = nil
        isNewValue = true
        result = getInteger()
        resultLabel.text = "×"
    }
    @IBAction func onDivision(_ sender: Any) {
        operation = .division
        previousOperation = nil
        isNewValue = true
        result = getInteger()
        resultLabel.text = "/"
    }
    
    @IBAction func onReset(_ sender: Any) {
        isNewValue = true
        result = 0
        newValue = 0
        operation = nil
        previousOperation = nil
        resultLabel.text = "0"
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = ConstantStrings.Calculator.title
    }
    
    func addDigit(_ digit: String) {
        if isNewValue {
            resultLabel.text = ""
            isNewValue = false
        }
        
        if resultLabel.text == "0" {
            return
        }
        
        var digits = resultLabel.text
        digits?.append(digit)
        
        if let text = digits, text.count > 9 {
            digits = String(text.prefix(9))
        }
        
        resultLabel.text = digits
    }
    
    func getInteger() -> Int {
        return Int(resultLabel.text ?? "0") ?? 0
    }
    
    func calculate() {
        guard let operation = operation else {
            return
        }

        if previousOperation != operation {
            newValue = getInteger()
        }
        
        do {
            try result = operation.makeOperation(result: result, newValue: newValue)
            var resultText = "\(result)"
            
            if resultText.count > 9 {
                resultText = String(resultText.prefix(9))
            }
            
            resultLabel.text = resultText
        } catch ErrorNull.divisionByZero {
            resultLabel.text = "Ошибка"
        } catch {
            resultLabel.text = "ERROR"
        }
                
        previousOperation = operation
        isNewValue = true
    }
}

enum ErrorNull: Error {
    case divisionByZero
}

enum MathOperation {
    case sum, minus, multiplication, division
    
    func makeOperation(result: Int, newValue: Int) throws -> Int {
        switch self {
        case .sum:
            return (result + newValue)
        case .minus:
            return (result - newValue)
        case .multiplication:
            return (result * newValue)
        case .division:
            guard newValue != 0 else { throw ErrorNull.divisionByZero }
            return (result / newValue)
        }
    }
}


