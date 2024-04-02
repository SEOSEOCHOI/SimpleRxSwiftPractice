//
//  ShoppingView.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/2/24.
//

import UIKit
import SnapKit

final class ShoppingView: UIView {
    let fieldView = UIView()
    let textfield = UITextField()
    let addButton = UIButton()
    
    let tableView = {
       let view = UITableView()
        view.register(ShoppingTableViewCell.self, forCellReuseIdentifier: "ShoppingTableViewCell")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
        backgroundColor = .white
        
        addSubview(fieldView)
        addSubview(tableView)
        fieldView.addSubview(textfield)
        fieldView.addSubview(addButton)
        
        fieldView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(8)
            make.top.equalTo(fieldView.snp.bottom).offset(8)
        }
        textfield.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(4)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        addButton.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalToSuperview().inset(4)
            make.leading.equalTo(textfield.snp.trailing).offset(4)
        }
        
        fieldView.backgroundColor = .lightGray
        tableView.backgroundColor = .white
        addButton.backgroundColor = .darkGray
        textfield.backgroundColor = .clear
        
        textfield.placeholder = "무엇을 구매하실 건가요?"
        addButton.setTitle("추가", for: .normal)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
