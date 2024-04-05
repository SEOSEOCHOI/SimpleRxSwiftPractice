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

    
    /*
     In
     1. 텍스트 필드 입력 <실시간 검색, 데이터 추가>
     2. 셀 클릭
     3. 체크 버튼 클릭
     4. 별 버튼 클릭
     5. 추가 버튼 클릭
     6. 삭제 버튼 클릭
     Out
     1. 입력된 테스트 반환 <실시간 검색, 데이터 추가>
     2. 셀 클릭
     3. 체크 버튼 클릭
     4. 별 버튼 클릭
     5. 추가 버튼 클릭
     6. 삭제 버튼 클릭
     */
    struct Input {
        let product: ControlProperty<String?>
        let addTap: ControlEvent<Void>
        let itemSelected: ControlEvent<IndexPath>
//        let checkTap: ControlEvent<Void>
//        let starTap: ControlEvent<Void>
//        let deleteTap: ControlEvent<Void>
        
    }
    
    struct Output {
        let product: Driver<String>
        let productList: Driver<[Shopping]>
        let addTap: ControlEvent<Void>
        //let itemSelected: ControlEvent<IndexPath>
    }
    

    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let product = input.product.orEmpty
        var inputShoppingValue: [Shopping] = [Shopping(item: "swift 공부", done: false, like: false),
                                              Shopping(item: "rxSwift 공부", done: false, like: false)]
        let inputShoppingList = BehaviorRelay(value: inputShoppingValue)
        
        product
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ?
                inputShoppingValue :
                inputShoppingValue.filter { $0.item.contains(value) }
                
                inputShoppingList.accept(result)
            }
            .disposed(by: disposeBag)

        input.addTap
            .withLatestFrom(product)
            .filter { $0 != "" }
            .subscribe(with: self) { owner, value in
                inputShoppingValue.append(Shopping(item: value, done: false, like: false))
                inputShoppingList.accept(inputShoppingValue)
                
            }
            .disposed(by: disposeBag)
        
        let productResult = product.asDriver()
        let productListResult = inputShoppingList.asDriver(onErrorJustReturn: [])
        
        input.itemSelected
            .subscribe(with: self, onNext: { owner, indexPath in
                let vc = EditViewController()
    
                vc.closure = { value in
                    inputShoppingValue[indexPath.row].item = value
                    inputShoppingList.accept(inputShoppingValue)
                }
            })
            .disposed(by: disposeBag)
                
        return Output(product: productResult,
                      productList: productListResult,
                      addTap: input.addTap)
    }


    

}

/*
 
 var inputShoppingList = PublishRelay<[Shopping]>()
 
 var inputTextField = PublishSubject<String>()
 var inputSearchText = PublishSubject<String>()
 let addButtonTap = PublishSubject<Void>()
 let itemSelected = PublishSubject<(EditViewController, Int)>()
 
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

 */
