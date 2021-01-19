//
//  ViewController.swift
//  combineTutorial
//
//  Created by Dustin on 2021/01/19.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    @IBOutlet weak var myBtn: UIButton!
    
    private var mySubscriptions = Set<AnyCancellable>()
    
    var viewModel : MyViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyViewModel()
        
        
        //텍스트 필드에서 나가는 이벤트를 뷰모델의 프로퍼티가 구독
        passwordTextField
            .myTextPublisher
            .print()
            //쓰레드 - 메인에서 받겠다.
            .receive(on: DispatchQueue.main)
            //KVO방식으로 구독
            //myviewmodel에 password input에 받는다
            .assign(to: \.passwordInput, on: viewModel)
            //메모리 관리
            .store(in: &mySubscriptions)
        
        
        passwordConfirmTextField
            .myTextPublisher
            .print()
            //쓰레드 - 다른 쓰레드와 같이 작업할때 많이 씀
            .receive(on: RunLoop.main)
            //KVO방식으로 구독
            //myviewmodel에 password input에 받는다
            .assign(to: \.passwordConfirmInput, on: viewModel)
            //메모리 관리
            .store(in: &mySubscriptions)
        
        
        
        //버튼이 뷰모델이 퍼블리셔를 구독
        
        viewModel.isMatchPasswordInput
            .print()
            //쓰레드 - 다른 쓰레드와 같이 작업할때 많이 씀
            .receive(on: RunLoop.main)
            // 구독
            .assign(to: \.isValid, on: myBtn)
            .store(in: &mySubscriptions)
    }
    
    
    
    
 
}

extension UITextField {
    
    var myTextPublisher : AnyPublisher<String,Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            
            // UITextField 가져 옴.
            .compactMap { $0.object as? UITextField }
            // String 가져옴
            .map { $0.text ?? "" }
            .print()
            .eraseToAnyPublisher()
    }
    
    
}


extension UIButton {
    var isValid : Bool {
        get {
            backgroundColor == .yellow
        }
        set {
            backgroundColor = newValue ? .yellow : . lightGray
            isEnabled = newValue
            setTitleColor(newValue ? .blue : .white, for: .normal)
        }
    }
}
