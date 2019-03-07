//
//  ViewController.swift
//  MyTipCalculator
//
//  Created by William Huynh on 3/3/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var billAmountTextField: UITextField!
    @IBOutlet weak var totalTipLabel: UILabel!
    @IBOutlet weak var numberOfPeoplePicker: UIPickerView!
    @IBOutlet weak var amountPerPersonLabel: UILabel!
    @IBOutlet weak var amountTotalLabel: UILabel!
    @IBOutlet weak var tipPercentagePicker: UIPickerView!
    
    var numberPickerData: [String] = [String]()
    
    var tipPickerData: [String] = [String]()
    
    var rotationAngle: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billAmountTextField.delegate = self
        
        self.numberOfPeoplePicker.delegate = self
        self.numberOfPeoplePicker.dataSource = self
        
        self.tipPercentagePicker.delegate = self
        self.tipPercentagePicker.dataSource = self
        
        let numArr: [Int] = Array(1...30)
        numberPickerData = numArr.map { String($0) }
        
        let tipArr: [Int] = Array(0...30)
        tipPickerData = tipArr.map { String($0) }
        
        self.tipPercentagePicker.selectRow(15, inComponent: 0, animated: false)
        self.numberOfPeoplePicker.selectRow(3, inComponent: 0, animated: false)
        
        calculateAmount()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onEditingChanged(_ sender: Any) {
        calculateAmount()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calculateAmount()
    }
    
    func calculateAmount() {
        var billAmount = NSString(string: billAmountTextField.text!).doubleValue
        let tipPercent = Double(tipPickerData[tipPercentagePicker.selectedRow(inComponent: 0)])
        
        if billAmountTextField.text!.count == 6{
            if billAmount < 100 {
                billAmount = billAmount * 10
                billAmount = round(100.0 * billAmount) / 100
                billAmountTextField.text = "\(billAmount)"
            }
        }
        else if billAmount > 100 {
            if billAmountTextField.text!.count == 5 {
                billAmount = round(10.0 * billAmount) / 100
                billAmountTextField.text = "\(billAmount)"
            }
            else {
                billAmount = billAmount / 10
                billAmountTextField.text = "\(billAmount)"
            }
        }
        
        let tip = billAmount * (tipPercent! / 100)
        let total = billAmount + tip
        let numberOfPeople = Double(numberPickerData[numberOfPeoplePicker.selectedRow(inComponent: 0)])
        
        
        totalTipLabel.text = String(format: "%.2f", tip)
        amountPerPersonLabel.text = String(format: "%.2f", total / numberOfPeople!)
        
        amountTotalLabel.text = String(format: "%.2f", total)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1){
            return tipPickerData.count
        }else{
            return numberPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1){
            return tipPickerData[row]
        }else{
            return numberPickerData[row]
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 6
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55.0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 50)
        
        if (pickerView.tag == 1){
            label.text =  tipPickerData[row]
            label.textAlignment = .center
            label.textColor = .white
            return label
        }else{
            label.text =  numberPickerData[row]
            label.textAlignment = .center
            label.textColor = .white
            return label
        }
    }

}

