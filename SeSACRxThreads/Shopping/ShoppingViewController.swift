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
    
    let viewModel = ShoppingViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
       // bind()
        bind2()
    }
    
    func bind2() {
        let product = mainView.textfield.rx.text
        let addTap = mainView.addButton.rx.tap
        let itemSelected = mainView.tableView.rx.itemSelected
        let input = ShoppingViewModel.Input(product: product,
                                            addTap: addTap,
                                            itemSelected: itemSelected)
        
        let output = viewModel.transform(input: input)
        
        // 1. 실시간 검색, 데이터 입력값
        output.product
            .drive(mainView.textfield.rx.text)
            .disposed(by: disposeBag)
        
        // cell
        output.productList
            .drive(mainView.tableView.rx.items(cellIdentifier: "ShoppingTableViewCell", cellType: ShoppingTableViewCell.self)) {indexPath, item, cell in
                cell.productLabel.text = item.item
               
                //            // 체크
//                            cell.doneButton.rx.tap.bind(with: self) { owner, _ in
//                                owner.viewModel.inputShoppingValue[indexPath].done.toggle()
//                                owner.viewModel.inputShoppingList.accept(owner.viewModel.inputShoppingValue)
//                            }
//                            .disposed(by: cell.disposeBag)
//                
//                            // 좋아요
//                            cell.likeButton.rx.tap.bind(with: self) { owner, _ in
//                                owner.viewModel.inputShoppingValue[indexPath].like.toggle()
//                                owner.viewModel.inputShoppingList.accept(owner.viewModel.inputShoppingValue)
//                            }
//                            .disposed(by: cell.disposeBag)
//                
//                            // 삭제
//                            cell.deleteButton.rx.tap.bind(with: self, onNext: { owner, _ in
//                                owner.viewModel.inputShoppingValue.remove(at: indexPath)
//                                owner.viewModel.inputShoppingList.accept(owner.viewModel.inputShoppingValue)
//                            })
//                            .disposed(by: cell.disposeBag)
                
                            cell.configureCell(item: item)
            }
            .disposed(by: disposeBag)
        
        // 추가 버튼
        output.addTap
            .subscribe(with: self) { owner, _ in
                print("tap")
            }
            .disposed(by: disposeBag)
        
        // tableview item selcted
        /*
         output.itemSelected.bind(with: self) { owner, indexPath in
                             let vc = EditViewController()
                             owner.navigationController?.pushViewController(vc, animated: true)
         }
         .disposed(by: disposeBag)
         */

        
        
    }
    
//    func bind() {
//        // ShoppingList Behavior Observable Subscirbe
//        viewModel.inputShoppingList.bind(to: mainView.tableView.rx.items(cellIdentifier: "ShoppingTableViewCell", cellType: ShoppingTableViewCell.self)) { (indexPath, item, cell) in
//            
//            cell.productLabel.text = item.item
//            
////            // 체크
//            cell.doneButton.rx.tap.bind(with: self) { owner, _ in
//                owner.viewModel.inputShoppingValue[indexPath].done.toggle()
//                owner.viewModel.inputShoppingList.accept(owner.viewModel.inputShoppingValue)
//            }
//            .disposed(by: cell.disposeBag)
//
//            // 좋아요
//            cell.likeButton.rx.tap.bind(with: self) { owner, _ in
//                owner.viewModel.inputShoppingValue[indexPath].like.toggle()
//                owner.viewModel.inputShoppingList.accept(owner.viewModel.inputShoppingValue)
//            }
//            .disposed(by: cell.disposeBag)
//            
//            // 삭제
//            cell.deleteButton.rx.tap.bind(with: self, onNext: { owner, _ in
//                owner.viewModel.inputShoppingValue.remove(at: indexPath)
//                owner.viewModel.inputShoppingList.accept(owner.viewModel.inputShoppingValue)
//            })
//            .disposed(by: cell.disposeBag)
//            
//            cell.configureCell(item: item)
//            
//        }
//        .disposed(by: disposeBag)
//
//        // 실시간 검색
//        mainView.textfield.rx
//            .text
//            .orEmpty
//            .subscribe(with: self) { owner, value in
//                owner.viewModel.inputSearchText.onNext(value)
//            }
//            .disposed(by: disposeBag)
//        
//        // 화면 전환
//        mainView.tableView.rx
//            .itemSelected
//            .subscribe(with: self) { owner, indexPath in
//                let vc = EditViewController()
//                owner.viewModel.itemSelected.onNext((vc, indexPath.row))
//                owner.navigationController?.pushViewController(vc, animated: true)
//                
//            }
//            .disposed(by: disposeBag)
//        
//        mainView.textfield.rx.text.orEmpty
//            .bind(to: viewModel.inputTextField)
//            .disposed(by: disposeBag)
//        
//        
//        mainView.addButton.rx.tap
//            .bind(to: viewModel.addButtonTap)
//            .disposed(by: disposeBag)
//    }

    

}
