//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/2/24.
//

import UIKit
import RxSwift
import RxCocoa

struct Shopping {
    var item: String
    var done: Bool
    var like: Bool
}

final class ShoppingViewController: UIViewController {
    let mainView = ShoppingView()
    override func loadView() {
        self.view = mainView
    }
    
    var inputShoppingValue: [Shopping] = [Shopping(item: "swift 공부", done: false, like: false),
                                          Shopping(item: "rxSwift 공부", done: false, like: false),
                                          Shopping(item: "readme 쓰기", done: false, like: false),
                                          Shopping(item: "블로그 쓰기", done: false, like: false),
                                          Shopping(item: "업데이트하기", done: false, like: false),
                                          Shopping(item: "할게 너무 마나...", done: false, like: false)]
    lazy var inputShoppingList = BehaviorSubject(value: inputShoppingValue)
    
    let disposeBag = DisposeBag()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
        // ShoppingList Behavior Observable Subscirbe
        inputShoppingList.bind(to: mainView.tableView.rx.items(cellIdentifier: "ShoppingTableViewCell", cellType: ShoppingTableViewCell.self)) { (indexPath, item, cell) in
            cell.productLabel.text = item.item
            
            // 체크
            cell.doneButton.rx.tap.bind(with: self) { owner, _ in
                owner.inputShoppingValue[indexPath].done.toggle()
                owner.inputShoppingList.onNext(owner.inputShoppingValue)
                
                print("doneButtonClicked, \(indexPath), \(item.done)")
            }
            .disposed(by: cell.disposeBag)
            
            // 좋아요
            cell.likeButton.rx.tap.bind(with: self) { owner, _ in
                owner.inputShoppingValue[indexPath].like.toggle()
                owner.inputShoppingList.onNext(owner.inputShoppingValue)
                print("likeButton, \(indexPath), \(item.like)")
            }
            .disposed(by: cell.disposeBag)
            
            // 삭제
            cell.deleteButton.rx.tap.bind(with: self, onNext: { owner, _ in
                owner.inputShoppingValue.remove(at: indexPath)
                owner.inputShoppingList.onNext(owner.inputShoppingValue)
            })
            .disposed(by: cell.disposeBag)
            
            // 좀 더 Rx스러울 순 없을지 . . .
            let doneImage = item.done ?
            UIImage(systemName: "checkmark.square.fill") :
            UIImage(systemName: "checkmark.square")
            
            let likeImage = item.like ?
            UIImage(systemName: "star.fill") :
            UIImage(systemName: "star")
            
            cell.doneButton.setImage(doneImage, for: .normal)
            cell.likeButton.setImage(likeImage, for: .normal)
            
        }
        .disposed(by: disposeBag)
        
        // 텍스트 입력 종료 시, inputShoppingValue 업데이트
        mainView.textfield.rx
            .controlEvent([.editingDidEnd, .editingDidEnd])
            .withLatestFrom(mainView.textfield.rx.text.orEmpty)
            .filter { $0 != "" }
            .subscribe(with: self) { owner, value in
                owner.inputShoppingValue.append(Shopping(item: value, done: false, like: false))
            }
            .disposed(by: disposeBag)
        
        // 실시간 검색
        mainView.textfield.rx
            .text
            .orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ?
                owner.inputShoppingValue :
                owner.inputShoppingValue.filter { $0.item.contains(value) }
                
                owner.inputShoppingList.onNext(result)
            }
            .disposed(by: disposeBag)
        
        // 화면 전환
        mainView.tableView.rx
            .itemSelected
            .subscribe(with: self) { owner, indexPath in
                let vc = EditViewController()
                // 수정
                vc.closure = { value in
                    owner.inputShoppingValue[indexPath.row].item = value
                    owner.inputShoppingList.onNext(owner.inputShoppingValue)
                }
                owner.navigationController?.pushViewController(vc, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        // 추가: 버튼 클릭 시 inputShoppingList onNext(inputShoppingValue)
        mainView.addButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.inputShoppingList.onNext(owner.inputShoppingValue)
            }
            .disposed(by: disposeBag)
        
        
    }

    

}
