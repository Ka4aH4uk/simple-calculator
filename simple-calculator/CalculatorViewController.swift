//
//  ViewController.swift
//  simple-calculator
//

import UIKit

class CalculatorViewController: UIViewController {
    var isNewValue = true
    var operation: MathOperation? = nil
    var previousOperation: MathOperation? = nil
    var result: Double = 0.0
    var newValue: Double = 0.0
    var percent: Double = 0.0
    
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
    
    @IBAction func onDecimal(_ sender: Any) {
        addDigit(".")
    }
    
    @IBAction func onPlusMinus(_ sender: Any) {
        guard var currentText = resultLabel.text, !currentText.isEmpty else {
            return
        }
        
        if currentText.first == "-", let number = Double(currentText), number != 0 {
            currentText.removeFirst()
        } else {
            guard let currentValue = Double(currentText) else {
                return
            }
            
            if currentValue != 0 {
                currentText.insert("-", at: currentText.startIndex)
            }
        }
        
        resultLabel.text = currentText
    }
    
    @IBAction func onEqual(_ sender: Any) {
        calculate()
    }
    
    @IBAction func onPlus(_ sender: Any) {
        operation = .sum
        previousOperation = nil
        isNewValue = true
        result = getNumber()
        resultLabel.text = "+"
    }
    
    @IBAction func onMinus(_ sender: Any) {
        operation = .minus
        previousOperation = nil
        isNewValue = true
        result = getNumber()
        resultLabel.text = "−"
    }
    
    @IBAction func onMultiplication(_ sender: Any) {
        operation = .multiplication
        previousOperation = nil
        isNewValue = true
        result = getNumber()
        resultLabel.text = "×"
    }
    
    @IBAction func onDivision(_ sender: Any) {
        operation = .division
        previousOperation = nil
        isNewValue = true
        result = getNumber()
        resultLabel.text = "/"
    }
    
    @IBAction func onReset(_ sender: Any) {
        isNewValue = true
        result = 0.0
        newValue = 0.0
        operation = nil
        previousOperation = nil
        resultLabel.text = "0"
    }
    
    @IBAction func onPercent(_ sender: Any) {
        getPercentage()
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
        
        if digit == "." && resultLabel.text?.contains(".") == true {
            return
        }
        
        if resultLabel.text == "0" && digit != "." {
            resultLabel.text = ""
        }
        
        if let text = resultLabel.text, text.count >= 9, digit == "." {
            return
        }
        
        resultLabel.text?.append(digit)
        
        if let text = resultLabel.text, text.count > 10 {
            resultLabel.text = String(text.prefix(10))
        }
    }
    
    func getNumber() -> Double {
        return Double(resultLabel.text ?? "0") ?? 0.0
    }
    
    func calculate() {
        guard let operation = operation else {
            return
        }
        
        if previousOperation != operation {
            newValue = (operation == .percent) ? getNumber() * percent : getNumber()
        }
        
        do {
            try result = operation.makeOperation(result: result, newValue: newValue)
            resultLabel.text = formatNumber(result)
        } catch ErrorNull.divisionByZero {
            resultLabel.text = "Ошибка"
        } catch {
            resultLabel.text = "Error"
        }
        
        previousOperation = operation
        isNewValue = true
    }
    
    func getPercentage() {
        guard let currentOperation = operation else {
            return
        }
        
        percent = getNumber() * 0.01
        result = try! currentOperation.makeOperation(result: result, newValue: result * percent)
        resultLabel.text = formatNumber(result)
        
        previousOperation = nil
    }
    
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.locale = Locale(identifier: "en_US")
        
        var resultText = formatter.string(from: NSNumber(value: number)) ?? "0"
        
        if resultText.count > 9 {
            resultText = String(resultText.prefix(9))
        }
        
        return resultText
    }
}

enum ErrorNull: Error {
    case divisionByZero
}

enum MathOperation {
    case sum, minus, multiplication, division, percent
    
    func makeOperation(result: Double, newValue: Double) throws -> Double {
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
        case .percent:
            return (result * (newValue / 100.0))
        }
    }
}
