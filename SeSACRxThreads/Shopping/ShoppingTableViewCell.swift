//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by 최서경 on 4/2/24.
//

import UIKit
import SnapKit
import RxSwift

final class ShoppingTableViewCell: UITableViewCell {
    let itemView = UIView()
    let doneButton = UIButton()
    let productLabel = UILabel()
    let likeButton = UIButton()
    let deleteButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configureView() {
        itemView.backgroundColor = .lightGray
        
        contentView.addSubview(itemView)
        
        [doneButton, productLabel, likeButton, deleteButton].forEach {
            itemView.addSubview($0)
        }
        
        itemView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(45)
        }
        
        doneButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        productLabel.snp.makeConstraints { make in
            make.leading.equalTo(doneButton.snp.trailing).offset(8)
            make.trailing.equalTo(deleteButton.snp.leading).offset(8)
            make.verticalEdges.equalToSuperview().inset(4)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(likeButton.snp.leading).offset(8)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.setTitle("삭제", for: .normal)
        
    }
}
