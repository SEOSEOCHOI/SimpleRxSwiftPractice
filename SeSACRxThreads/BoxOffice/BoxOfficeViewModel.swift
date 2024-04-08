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
    
    var recent = ["테스트", "테스트1", "테스트2"]
    let movie = Observable.just(["테스트10", "테스트11", "테스트12"])
    
    /*
     1. 셀 클릭 -> 최근 검색어 전달   
     2. 검색어
     3. 검색 버튼 클릭
     */
    struct Input {
        let recentText: PublishSubject<String>
        let searchText: ControlProperty<String>
        let searchTap: ControlEvent<Void>
    }
    
    struct Output {
        let recentList: BehaviorRelay<[String]>
        let boxOfficeList: PublishSubject<[DailyBoxOfficeList]>
    }
    
    
    func transform(input: Input) -> Output {
        
        let recentList = BehaviorRelay(value: recent)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        
        // 셀 클릭. 최근 검색 기록
        input.recentText
            .debug()
            .subscribe(with: self) { owner, value in
                owner.recent.append(value)
                recentList.accept(owner.recent)
            }
            .disposed(by: disposeBag)
        
        // 검색 시 기록
        input.searchTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .map { guard let intText = Int($0)
                else { return 20240405 }
            return intText }
            .map { String($0) }
            .flatMap { BoxOfficeNetwork.fetchSingleBoxOfficeData(date: $0)
                    .catch { error in // Error일 경우  Emit X . 스트림 중단 없음.
                        return Single<Movie>.never()
                    }}
            .subscribe(with: self, onNext: { owner, value in
                let data = value.boxOfficeResult.dailyBoxOfficeList
                boxOfficeList.onNext(data)
                print("Transform Next")
            }, onError: { _, _ in
                print("Transform Error")
            }, onCompleted: { _ in
                print("Transform Completed")

            }, onDisposed: { _ in
                print("Transform Disposed")

            })
            .disposed(by: disposeBag)
        return Output(recentList: recentList,
                      boxOfficeList: boxOfficeList)
    }
    
    
}




