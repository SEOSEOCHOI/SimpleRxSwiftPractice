//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
   
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    let viewModel = PasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()

    }
    
    func bind() {
        let password = passwordTextField.rx.text
        let nextTap = nextButton.rx.tap
        
        let input = PasswordViewModel.Input(password: password, nextTap: nextTap)
        
        let output = viewModel.transform(input: input)
        
        output.password
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.nextTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.validate
            .drive(with: self, onNext: { owner, value in
                let color: UIColor = value ? .systemPink : .lightGray
                
                owner.nextButton.backgroundColor = color
                owner.nextButton.isEnabled = value
                owner.descriptionLabel.isHidden = value
            })
            .disposed(by: disposeBag)
        
        output.validateMessage
            .drive(descriptionLabel.rx.text).disposed(by: disposeBag)
        
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
         
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(passwordTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
