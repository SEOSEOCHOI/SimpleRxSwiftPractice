//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

/*
 input
 - 비밀번호 입력
 - 다음 버튼 클릭
 output
 - 비밀번호 입력 내용
 - 비밀번호 조건
 - 비밀번호 조건에 따른 메시지
 - 다음 버튼 클릭
 */
class PasswordViewModel {
    struct Input {
        let password: ControlProperty<String?>
        let nextTap: ControlEvent<Void>
    }
    
    struct Output {
        let password: Driver<String>
        let validate: Driver<Bool>
        let validateMessage: Driver<String>
        let nextTap: ControlEvent<Void>
    }
    
        //let validationText =
    
    func transform(input: Input) -> Output {
        let password = input.password
            .orEmpty
            .asDriver()
        let validate = input.password
            .orEmpty
            .map { $0.count > 8}
            .asDriver(onErrorJustReturn: false)
        
        let message = BehaviorRelay(value: "8자 이상 입력해 주세요").asDriver()

        return Output(password: password,
                      validate: validate,
                      validateMessage: message,
                      nextTap: input.nextTap)
    }
}
