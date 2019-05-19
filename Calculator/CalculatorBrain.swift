//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 홍주연 on 13/05/2019.
//  Copyright © 2019 hongjuyeon. All rights reserved.
//

//Foundation is core service layer
//model에서는 uikit을 사용하는 일이 절대 없음
import Foundation

//how to operate Optional
//enum Optional<T> {
//    case None
//    case Some(T)
//}

//struct: class처럼 저장변수나 계산 변수같은 var는 가질 수 있지만 상속 불가능. class와 가장 다른 점은 struct는 enum처럼 '값'으로 전달됨. class는 '참조'형식으로 전달됨. 참조형식으로 전달된다는 것은 메모리(힙) 어딘가에 있다가 실제로는 메모리 주소를 전달하는 것. 값으로 전달한다는 것은 전달할 때 복사해서 전달하는 것
/*
 ~~~~closure~~~~
 - 기본적으로 인라인 함수라고 생각 (인라인 함수: 함수 호출 없이 그 위치에서 바로 실행되는 함수)
 - 환경상태를 그대로 캡쳐하는 함수
 - 입력인자 앞에 { 가 오고 뒤에 in 이 온다민 빼면 함수 만드는 방법과 동일
 
 Operation.BinaryOperation({ (op1: Double, op2: Double) -> Double in return op1 * op2})
 Operation.BinaryOperation({ (op1, op2) in return op1 * op2})
 Operation.BinaryOperation({ ($0, $1) in return $0 * $1 })
 Operation.BinaryOperation({ return $0 * $1 })
 Operation.BinaryOperation({ $0 * $1 })
 */


//객체 안에서 영구적으로 지원하려는 것만 public으로 만들기

class CalculatorBrain {
    
    private var accumulator = 0.0 //연산이 수행될 때마다 결과를 누적시킬 변수
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary <String, Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation { //enum: 별개의 값을 모아놓은 세트, swift에서는 enum이 함수를 가질 수 있다. 하지만 변수를 가질 순 없음. 계산 변수를 가질 수 있지만 저장 변수를 가질 수 없음, 값으로 전달됨
        case Constant(Double) //상수
        case UnaryOperation((Double)-> Double)//단항연산
        case BinaryOperation((Double, Double) -> Double) //이항연산
        case Equals //=
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryfunction: function, firstOperand: accumulator )
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil { //현재 대기중인 연산이 있다면
            accumulator = pending!.binaryfunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo { //대기중인 이항연산 정보
        var binaryfunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    //get만 하기 때문에 result는 readonly property
    var result: Double{
        get{
            return accumulator
        }
    }
}
