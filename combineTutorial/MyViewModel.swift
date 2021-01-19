//
//  MyViewModel.swift
//  combineTutorial
//
//  Created by Dustin on 2021/01/19.
//

import UIKit
import Combine

class MyViewModel {
    
    
    @Published var passwordInput : String = "" {
        didSet {
            print("MyViewModel / passwordInput : \(passwordInput)")
        }
    }
    @Published var passwordConfirmInput : String = "" {
        didSet {
            print("MyViewModel / passwordConfirmInput : \(passwordConfirmInput)")
        }
        
    }
    
    // 들어온 퍼블리셔들의 값 일치 여부를 반환 하는 퍼블리셔
    lazy var isMatchPasswordInput : AnyPublisher<Bool, Never> = Publishers.CombineLatest($passwordInput, $passwordConfirmInput)
        .map({(password : String , passwordConfirm : String) in
            
            //값이 빈 값이 일때
            if password == "" || passwordConfirm == "" {
                return false
            }
            
            if password == passwordConfirm {
                return true
            } else {
                return false
            }
            
            
        })
        .print()
        .eraseToAnyPublisher()
    
}
