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
    
    var inputTextList: [String] = []
    let inputText = PublishSubject<[String]>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bind()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func bind() {
        
        inputText.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (indexpath, element, cell) in
            cell.textLabel?.text = "\(element)"
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.inputTextList.remove(at: indexPath.row)
                owner.inputText.onNext(owner.inputTextList)
            }
            .disposed(by: disposeBag)
        
        
        textField.rx
            .controlEvent([.editingDidEndOnExit])
            .withLatestFrom(textField.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, value in
                owner.inputTextList.append(value)
            }
            .disposed(by: disposeBag)

        
        addButton.rx.tap.subscribe(with: self) { owner, _ in
            owner.inputText.onNext(owner.inputTextList)
        }
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
