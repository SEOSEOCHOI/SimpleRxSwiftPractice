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
    
    let viewModel = SampleViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        bind()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func bind() {
        viewModel.inputText.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (indexpath, element, cell) in
            cell.textLabel?.text = "\(element)"
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                owner.viewModel.inputTextList.remove(at: indexPath.row)
                owner.viewModel.inputText.onNext(owner.viewModel.inputTextList)
            }
            .disposed(by: disposeBag)
        
        textField.rx
            .controlEvent([.editingDidEndOnExit])
            .withLatestFrom(textField.rx.text.orEmpty)
            .bind(with: self, onNext: { owner, value in
                owner.viewModel.inputTextList.append(value)
            })
            .disposed(by: disposeBag)
        
        // 추가 버튼
        addButton.rx.tap
            .bind(to: viewModel.addButtonClicked)
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
