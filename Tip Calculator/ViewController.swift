//
//  ViewController.swift
//  paulSolt2
//
//  Created by Axel Kaliff on 2018-02-04.
//  Copyright © 2018 Axel Kaliff. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        billTextField.delegate = self
        
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyBoardDidChange(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyBoardDidChange(notification:)), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyBoardDidChange(notification:)), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //Outlets
    @IBOutlet weak var tip1label: UILabel!
    @IBOutlet weak var tip2label: UILabel!
    @IBOutlet weak var tip3label: UILabel!
    @IBOutlet weak var billTextField: UITextField!
    
    
    //Actions
    @IBAction func calcTipButton(_ sender: Any) {
        hideKeyboard()
        calcAllTips()
    }
    
    //Methods
    func hideKeyboard() {
        billTextField.resignFirstResponder()
    }
    
    func calcAllTips() {
        guard let subtotal = convertCurrencyToDouble(input: billTextField.text!) else {
            print("Invalif number: \(billTextField.text!)")
            return
        }
        
        //calc tips
        let tip1 = calcTip(subtotal: subtotal, tipsPercentage: 10.0)
        let tip2 = calcTip(subtotal: subtotal, tipsPercentage: 15.0)
        let tip3 = calcTip(subtotal: subtotal, tipsPercentage: 20.0)
        
        //update UI
        tip1label.text = convertDoubleToCurrency(amount: tip1)
        tip2label.text = convertDoubleToCurrency(amount: tip2)
        tip3label.text = convertDoubleToCurrency(amount: tip3)
    }
    
    func calcTip(subtotal: Double, tipsPercentage: Double) -> Double {
        return subtotal * (tipsPercentage / 100.0)
    }
    
    func convertCurrencyToDouble(input: String) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.number(from: input)?.doubleValue
    }

    
    func convertDoubleToCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @objc func keyBoardDidChange(notification: Notification) {
        
        //actual keyboard height
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        
        //show or hide
        if notification.name ==  Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardDidChangeFrame {
            view.frame.origin.y = -keyboardRect.height
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
}

