//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }()
  
    let nextButton = PointButton(title: "가입하기")
    
    let viewModel = BirthdayViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        
    }
    
    func bind() {
        birthDayPicker.rx.date
            .bind(to: viewModel.birthday)
            .disposed(by: disposeBag)
        
        viewModel.year
            .asDriver(onErrorJustReturn: 2024)
            .map { "\($0)년"}
            .drive(yearLabel.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.month
            .asDriver()
            .map { "\($0)월" }
            .drive(monthLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.day
            .asDriver(onErrorJustReturn: 03)
            .drive(with: self, onNext: { owner, value in
                owner.dayLabel.text = "\(value)일"
            })
            .disposed(by: disposeBag)


        let validation = birthDayPicker.rx.date
            .map { Calendar.current.date(byAdding: .year, value: 17, to: $0)! <= Date()}
         
         
        validation.subscribe(with: self) { owner, value in
            let textColor: UIColor = value ? .systemBlue : .systemRed
            let buttonColor: UIColor = value ? .systemBlue : .lightGray
            let infoText: String = value ? "가입 가능합니다." : "만 17세 이상 가입 가능합니다."
            
            
            owner.infoLabel.textColor = textColor
            owner.nextButton.backgroundColor = buttonColor
            owner.nextButton.isEnabled = value
           
            owner.viewModel.validationText.accept(infoText)
        }
         .disposed(by: disposeBag)
        
        viewModel.validationText
            .asDriver()
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.view.window?.rootViewController = SampleViewController()
                owner.view.window?.makeKeyAndVisible()
                
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
