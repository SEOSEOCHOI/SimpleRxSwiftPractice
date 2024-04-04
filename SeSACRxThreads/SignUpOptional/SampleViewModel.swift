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
    /*
     Input
      - 추가 버튼 클릭
      - 셀 클릭
      - 텍스트 필드 입력
     
     Output
      - 텍스트 필드 입력 내용
      - 추가 버튼 클릭
      - 셀 클릭
      - 입력된 내용 리스트화하기...??!!
     */
    
    
    struct Input {
        let addButtonTap: ControlEvent<Void>
        let itemSelected: ControlEvent<IndexPath>
        let inputText: ControlProperty<String?>
    }
    
    struct Output {
        let outputList: Driver<[String]>
        let addButtonTap: ControlEvent<Void>
       // let itemSelected: ControlEvent<IndexPath>
    }
    
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        var outputTextList: [String] = []
        let outputList = PublishRelay<[String]>()
        
        let outputText = input.inputText.orEmpty
        
        input.addButtonTap
            .withLatestFrom(outputText)
            .subscribe(with: self, onNext: { owner, value in
                outputTextList.append(value)
                outputList.accept(outputTextList)
            })
            .disposed(by: disposeBag)
        
        input.itemSelected
            .subscribe(with: self) { owner, indexPath in
                outputTextList.remove(at: indexPath.row)
                outputList.accept(outputTextList)
            }
            .disposed(by: disposeBag)
        let outputResult = outputList
            .asDriver(onErrorJustReturn: [])
        
        return Output(outputList: outputResult,
                      addButtonTap: input.addButtonTap)
    }

}
