//
//  BirthDayViewModel.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 3/29/24.
//

import Foundation
import RxSwift
import RxCocoa

class BirthdayViewModel {

    let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
    
    let year = PublishRelay<Int>()
    let month = BehaviorRelay(value: 4)
    let day = PublishRelay<Int>()
    
    let validationText = BehaviorRelay(value: "만 17세 이상 가입 가능합니다.")
    
    let disposeBag = DisposeBag()

    init() {

        birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                owner.year.accept(component.year!)
                owner.month.accept(component.month!)
                owner.day.accept(component.day!)
                
            }
            .disposed(by: disposeBag)
    }
}
