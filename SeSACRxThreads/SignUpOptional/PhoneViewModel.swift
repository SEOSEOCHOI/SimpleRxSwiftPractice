//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class PhoneViewModel {
    
    let phoneNumber = BehaviorSubject(value: "010")
    
    let outputPhoneNumber = BehaviorSubject(value: "010")
    
    let disposeBag = DisposeBag()
    
    init() {
        phoneNumber
            .map { $0.filter { $0.isNumber }}
            .bind(to: outputPhoneNumber)
            .disposed(by: disposeBag)
    }
}
