//
//  EditViewController.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EditViewController: UIViewController {
    
    let textField = UITextField()
    var closure: ((String) -> ())?
    
    var outputText = PublishSubject<String>()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bind()
    }
    
    func bind() {
        outputText.subscribe(with: self) { owner, value in
            owner.closure?(value)
        }
        .disposed(by: disposeBag)
        
        textField.rx
            .controlEvent(.editingDidEnd)
            .withLatestFrom(textField.rx.text.orEmpty)
            .filter { $0 != "" }
            .subscribe(with: self) { owner, value in
                owner.outputText.onNext(value)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(8)
        }
        
        textField.placeholder = "수정할 값을 입력해 주세요"
    }
    

}
