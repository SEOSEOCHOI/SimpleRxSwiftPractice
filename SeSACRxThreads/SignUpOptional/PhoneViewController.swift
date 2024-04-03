//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    let disposeBag = DisposeBag()
    
    let viewModel = PhoneViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        let validation = phoneTextField         
            .rx
            .text
            .orEmpty
            .map { $0.count > 10 }
        
        viewModel.outputPhoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        phoneTextField.rx.textInput.text.orEmpty
            .asDriver()
            .drive(viewModel.phoneNumber)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
            }
            .disposed(by: disposeBag)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
