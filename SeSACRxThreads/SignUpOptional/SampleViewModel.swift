//
//  SampleViewModel.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class SampleViewModel {
    var inputTextList: [String] = []
    let inputText = PublishSubject<[String]>()
    
    let addButtonClicked = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    init() {
        addButtonClicked.subscribe(with: self) { owner, _ in
            owner.inputText.onNext(owner.inputTextList)
        }
        .disposed(by: disposeBag)
    }
}

