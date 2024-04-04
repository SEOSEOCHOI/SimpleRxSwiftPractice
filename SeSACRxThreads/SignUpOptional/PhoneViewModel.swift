//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

/*
 Input
  - 전화번호 입력
  - 다음 버튼 클릭
 Output
  - 입력된 전화번호 반환
  - 다음 버튼 입력 조건
  - 다음 버튼 클릭
 */
class PhoneViewModel {
    struct Input {
        let phoneNumber: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let phoneNumber: Driver<String>
        let nextButtonTap: ControlEvent<Void>
        let validation: Driver<Bool>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let phoneNumber = BehaviorSubject(value: "010")
        
        phoneNumber
            .bind(to: input.phoneNumber)
            .disposed(by: disposeBag)
//
        input.phoneNumber
            .orEmpty
            .map { $0.filter { $0.isNumber } }
            .bind(to: phoneNumber)
            .disposed(by: disposeBag)
        
        let phoneNumerResult = phoneNumber.asDriver(onErrorJustReturn: "")
        
        let validation = input.phoneNumber
            .orEmpty
            .map { $0.count > 10 }
            .asDriver(onErrorJustReturn: false)
        
        
        return Output(phoneNumber: phoneNumerResult,
                      nextButtonTap: input.nextButtonTap,
                      validation: validation)
    }

}
