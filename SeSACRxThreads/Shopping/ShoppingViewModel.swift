//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingViewModel {
    var inputShoppingValue: [Shopping] = [Shopping(item: "swift 공부", done: false, like: false),
                                          Shopping(item: "rxSwift 공부", done: false, like: false),
                                          Shopping(item: "readme 쓰기", done: false, like: false),
                                          Shopping(item: "블로그 쓰기", done: false, like: false),
                                          Shopping(item: "업데이트하기", done: false, like: false),
                                          Shopping(item: "할게 너무 마나...", done: false, like: false)]
    
    var inputShoppingList = PublishRelay<[Shopping]>()
    
    var inputTextField = PublishSubject<String>()
    var inputSearchText = PublishSubject<String>()
    let addButtonTap = PublishSubject<Void>()
    let itemSelected = PublishSubject<(EditViewController, Int)>()
    let disposeBag = DisposeBag()
    
    init() {
        // 추가 버튼 클릭
        addButtonTap
            .withLatestFrom(inputTextField)
            .subscribe(with: self) { owner, value in
                owner.inputShoppingValue.append(Shopping(item: value, done: false, like: false))
                owner.inputShoppingList.accept(owner.inputShoppingValue)
            }
            .disposed(by: disposeBag)
        
        // 실시간 검색
        inputSearchText
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ?
                owner.inputShoppingValue :
                owner.inputShoppingValue.filter { $0.item.contains(value) }
                
                owner.inputShoppingList.accept(result)
            }
            .disposed(by: disposeBag)
        
        itemSelected.subscribe(with: self, onNext: { owner, value in
            self.transition(vc: value.0, indexPath: value.1)
        })
        .disposed(by: disposeBag)
        
    }
    
    func transition(vc: EditViewController,indexPath: Int) {
        // 메서드를 호출하는 방식
        vc.closure = { value in
            self.inputShoppingValue[indexPath].item = value
            self.inputShoppingList.accept(self.inputShoppingValue)
        }
    }
}
