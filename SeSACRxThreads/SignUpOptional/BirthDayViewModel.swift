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
    let year = BehaviorRelay(value: 2024)
    let month = BehaviorRelay(value: 03)
    let day = BehaviorRelay(value: 29)

    let disposeBag = DisposeBag()

    init() {
        birthday.subscribe(with: self) { owner, date in
            let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
            owner.year.accept(component.year!)
            owner.month.accept(component.month!)
            owner.day.accept(component.day!)
            print(date)
        } onDisposed: { owner in
            print("birthday disposed")
        }
        .disposed(by: DisposeBag())

    }
}
