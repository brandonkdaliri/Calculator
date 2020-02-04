//
//  ViewController.swift
//  Calculator
//
//  Created by Brandon Daliri on 2020-01-25.
//  Copyright © 2020 Brandon Daliri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let NUM_BUTTONS = 20;
    var labelValue: Double = 0;
    var oldLabelValue: Double = 0;
    var operatorBtn: Bool = false;
    var calculating: Bool = true;
    var error: Bool = false;
    var prevAns: Double = 0;
    var tempValue: Double = 0;
    var numTerms: Int = 0;
    var operand: Arithmetic?;
    var prevOperand: Arithmetic?;
    enum Arithmetic {
        case ADD, SUB, DIV, MULT
    }
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var oldLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Auto adjust label font size to fit width
        label.adjustsFontSizeToFitWidth = true;
        label.minimumScaleFactor = 0.7;
        
        // Rounding buttons
        for i in 0...NUM_BUTTONS {
            if let button = self.view.viewWithTag(i) as? UIButton
            {
                button.layer.cornerRadius = 50;
            }
        }
    }

    @IBAction func numbers(_ sender: UIButton) {
        if (operatorBtn) {
            deselectButtons();
            label.text = "";
        }
        if (label.text!.count < 12) {
            if (!calculating) {
                label.text = "";
                calculating = true;
            }
            if let button = self.view.viewWithTag(11) as? UIButton {
                if (button.currentTitle == "AC") {
                    button.setTitle("C", for: .normal);
                }
            }
            if (label.text == "0") {
                label.text = String(sender.tag-1);
            } else {
                label.text = label.text! + String(sender.tag-1);
            }
        }
    }
    
    @IBAction func decimal(_ sender: UIButton) {
        if (operatorBtn) {
            deselectButtons();
            label.text = "";
        }
        
        if (label.text!.count < 12) {
            if (!calculating) {
                label.text = "0";
                calculating = true;
            }
            
            if (!label.text!.contains(".")){
                label.text = label.text! + ".";
            }
        }
    }
    
    @IBAction func clearLabel(_ sender: UIButton) {
        label.text = "0";
        labelValue = 0;
        if (!calculating) {
            oldLabel.text = "";
            oldLabelValue = 0;
            numTerms = 0;
            prevOperand = .none;
            deselectButtons();
        }
        if let button = self.view.viewWithTag(11) as? UIButton {
            if (button.currentTitle == "AC") {
                oldLabel.text = "";
                oldLabelValue = 0;
                numTerms = 0;
                prevOperand = .none;
                deselectButtons();
            } else if (button.currentTitle == "C") {
                button.setTitle("AC", for: .normal);
            }
        }
    }
    
    @IBAction func invertSign(_ sender: UIButton) {
        let temp: Double = Double(label.text!)! * -1;
        if (floor(temp) == temp) {
            label.text = String(Int(temp));
        }
    }
    
    @IBAction func prevAns(_ sender: UIButton) {
        if (floor(prevAns) == prevAns){
            label.text = String(Int(prevAns));
        } else {
            label.text = String(prevAns);
        }
    }
    // Arithmetic Operations
    @IBAction func add(_ sender: UIButton) {
        numTerms+=1;
        prevOperand = operand;
        operand = .ADD;
        deselectButtons();
        selectButton(tag: 17);
        
        if (!calculating) {
            oldLabel.text = "";
        }
        
        if (numTerms > 1) {
            calculate();
            oldLabel.text = oldLabel.text! + " + ";
        } else if (!error) {
            oldLabelValue = Double(label.text!)!;
            oldLabel.text = oldLabel.text! + label.text! + " + ";
        }
    }
    
    @IBAction func subtract(_ sender: UIButton) {
        numTerms+=1;
        prevOperand = operand;
        operand = .SUB;
        deselectButtons();
        selectButton(tag: 16);
        
        if (!calculating) {
            oldLabel.text = "";
        }
        
        if (numTerms > 1){
            calculate();
            oldLabel.text = oldLabel.text! + " - ";
        } else if (!error) {
            oldLabelValue = Double(label.text!)!;
            oldLabel.text = oldLabel.text! + label.text! + " - ";
        }
    }
    
    @IBAction func multiply(_ sender: UIButton) {
        numTerms+=1;
        prevOperand = operand;
        operand = .MULT;
        deselectButtons();
        selectButton(tag: 15);
        
        if (!calculating) {
            oldLabel.text = "";
        }
        
        if (numTerms > 1){
            calculate();
            oldLabel.text = oldLabel.text! + " * ";
        } else if (!error) {
            oldLabelValue = Double(label.text!)!;
            oldLabel.text = oldLabel.text! + label.text! + " * ";
        }
    }
    
    @IBAction func divide(_ sender: UIButton) {
        numTerms+=1;
        prevOperand = operand;
        operand = .DIV;
        deselectButtons();
        selectButton(tag: 14);
        
        if (!calculating) {
            oldLabel.text = "";
        }
        
        if (numTerms > 1) {
            calculate();
            oldLabel.text = oldLabel.text! + " / "
        } else if (!error) {
            oldLabelValue = Double(label.text!)!;
            oldLabel.text = oldLabel.text! + label.text! + " / ";
        }
    }
    
    func calculate() {
        if (!error) {
            labelValue = Double(label.text!)!;
            oldLabel.text = oldLabel.text! + label.text! + " = ";
        }
        
        switch prevOperand {
        case .ADD:
            oldLabelValue = oldLabelValue + labelValue;
            break;
        case .SUB:
            oldLabelValue = oldLabelValue - labelValue;
            break;
        case .MULT:
            oldLabelValue = oldLabelValue * labelValue;
            break;
        case .DIV:
            if (labelValue == 0) {
                error = true;
                break;
            } else {
                oldLabelValue = oldLabelValue / labelValue;
                break;
            }
        case .none:
            break;
        }
        
        if (error) {
            label.text = "Error";
        } else {
            // checking if result is an integer
            if (floor(oldLabelValue) == oldLabelValue) {
                oldLabel.text = String(Int(oldLabelValue));
            }else {
                oldLabel.text = String(oldLabelValue);
            }
            prevAns = oldLabelValue;
        }
        
        numTerms = 1;
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        if (!error) {
            labelValue = Double(label.text!)!;
            if (numTerms > 0){
                oldLabel.text = oldLabel.text! + label.text! + " = ";
            }
        }
        
        switch operand {
        case .ADD:
            prevOperand = operand;
            tempValue = labelValue;
            labelValue = oldLabelValue + labelValue;
            break;
        case .SUB:
            prevOperand = operand;
            tempValue = labelValue;
            labelValue = oldLabelValue - labelValue;
            break;
        case .MULT:
            prevOperand = operand;
            tempValue = labelValue;
            labelValue = oldLabelValue * labelValue;
            break;
        case .DIV:
            if (labelValue == 0) {
                error = true;
                break;
            } else {
                prevOperand = operand;
                tempValue = labelValue;
                labelValue = oldLabelValue / labelValue;
                break;
            }
        case .none: // if no operand, simply repeat the previous operand with same value
            var tempString: String = "";
            if (floor(tempValue) == tempValue) {
                tempString = String(Int(tempValue));
            }else {
                tempString = String(tempValue);
            }
            switch prevOperand {
            case .ADD:
                oldLabel.text = label.text! + " + " + tempString + " = ";
                labelValue = labelValue + tempValue;
                break;
            case .SUB:
                oldLabel.text = label.text! + " - " + tempString + " = ";
                labelValue = labelValue - tempValue;
                break;
            case .MULT:
                oldLabel.text = label.text! + " * " + tempString + " = ";
                labelValue = labelValue * tempValue;
                break;
            case .DIV:
                if (!error) {
                    oldLabel.text = label.text! + " / " + tempString + " = ";
                    labelValue = labelValue / tempValue;
                }
                break;
            case .none:
                return;
            }
            break;
        }
        
        if (error) {
            label.text = "Error";
        } else {
            // checking if result is an integer
            if (floor(labelValue) == labelValue) {
                label.text = String(Int(labelValue));
            }else {
                label.text = String(labelValue);
            }
            prevAns = labelValue;
        }
        
        calculating = false;
        operand = .none;
    }
    
    // Auxiliary Functions
    func deselectButtons() {
        for i in 14...18 {
            if let button = self.view.viewWithTag(i) as? UIButton {
                button.setTitleColor(UIColor.white, for: .normal);
                button.backgroundColor = UIColor(red: 1, green: 148/255, blue: 3/255, alpha: 1.0);
            }
        }
        operatorBtn = false;
    }
    
    func selectButton(tag: Int){
        if let button = self.view.viewWithTag(tag) as? UIButton {
            button.setTitleColor(UIColor(red: 1, green: 148/255, blue: 3/255, alpha: 1.0), for: .normal);
            button.backgroundColor = UIColor.white;
        }
        operatorBtn = true;
    }
}

