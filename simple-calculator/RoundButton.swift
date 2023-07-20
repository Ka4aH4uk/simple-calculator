//
//  RoundButton.swift
//  simple-calculator
//

import UIKit

@IBDesignable

class RoundButton: UIButton {
    @IBInspectable var roundButton: Bool = false {
        didSet {
            if roundButton {
                layer.cornerRadius = frame.height / 3
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if roundButton {
            layer.cornerRadius = frame.height / 3
        }
    }
}
