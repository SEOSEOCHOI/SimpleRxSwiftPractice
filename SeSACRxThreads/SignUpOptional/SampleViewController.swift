//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 3/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    
    let addButton = PointButton(title: "추가")
    let textField = SignTextField(placeholderText: "내용을 입력해 주세요")
    let tableView = UITableView()
    
    let inputText = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    // 퍼블릭으로 아이템 담기ㅂ
   // let list: PublishSubject

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bind()
    }

    func bind() {
        inputText.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = "\(element)"
        }
        .disposed(by: disposeBag)
        
        addButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.textField.rx.text.orEmpty.subscribe(with: self) { owner, text in
                owner.inputText.onNext(text)
            }
        }
        .disposed(by: disposeBag)
        
//        textField.rx.controlEvent([.editingDidEnd, .editingDidBegin])
//            .asObservable()
//            .subscribe(with: self) { owner, value in
////                owner.inputText.onNext(value)
//            print(owner.inputText)
//        }
//        .disposed(by: disposeBag)
        
        textField
              .rx.textInput.text.orEmpty
              .asDriver()
              .drive(onNext: { [unowned self] text in
                  print(text)
              })
              .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected.subscribe(with: self) { owner, indexPath in
            print(indexPath.row)
           
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .subscribe(with: self, onNext: { owner, indexPath in
            })
            .disposed(by: disposeBag)
    }

    func configureLayout() {
        tableView.backgroundColor = .brown
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(addButton)
        view.addSubview(textField)
        view.addSubview(tableView)
        
        addButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
            make.width.equalTo(60)
        }
        textField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(addButton.snp.leading)
            make.height.equalTo(addButton.snp.height)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
