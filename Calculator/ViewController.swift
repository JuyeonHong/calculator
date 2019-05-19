//
//  ViewController.swift
//  Calculator
//
//  Created by 홍주연 on 16/04/2019.
//  Copyright © 2019 hongjuyeon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false //: Bool을 안써줘도 되는 이유는 false는 타입이 Bool밖에 될 수 없음
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func touchDigit(_ sender: UIButton){ //메소드 인자 - 이름: 타입, sender가 anyobject가 아닌 uibutton인 것에 주의
        
        let digit = sender.currentTitle! //optinal인 이유는 title이 set되지 않은 버튼을 가질지도 모르기 때문
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
            
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double{ //연산 프로퍼티
        get{ //저장된 값을 읽어올 때
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    //controller가 model을 가지려면  직접 말을 할 수 있어야함
    private var brain = CalculatorBrain()//이 변수에게 모든 계산을 시킬 예정
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
    
        if let mathmaticalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathmaticalSymbol)
        }
        displayValue = brain.result
    }
    
    
}

