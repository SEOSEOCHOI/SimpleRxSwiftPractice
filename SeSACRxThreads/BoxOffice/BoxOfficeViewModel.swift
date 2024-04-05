//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
     
    let disposeBag = DisposeBag()
    
    let recent = Observable.just(["테스트", "테스트1", "테스트2"])
    let movie = Observable.just(["테스트10", "테스트11", "테스트12"])
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    
    func transform(input: Input) -> Output {
          
        return Output()
    }
    
    
}




