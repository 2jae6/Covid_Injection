//
//  DetailViewController.swift
//  Covid
//
//  Created by Jay on 2022/01/13.
//

import RxCocoa
import RxSwift
import Then
import UIKit


final class DetailViewController: UIViewController {
    let viewModel: DetailViewModelType
    let disposeBag = DisposeBag()

    init(with viewModel: DetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
       setup()
        
        viewModel.output.list
            .withUnretained(self)
            .subscribe(onNext: { `self`, centerModel in
                self.title = centerModel.address
                self.drawView(
                    centerData: centerModel.facilityName,
                    facilityNameData: centerModel.facilityName,
                    callData: centerModel.phoneNumber,
                    updatedAtData: centerModel.updatedAt,
                    locationData: centerModel.address
                )

                self.view.setNeedsLayout()

            })
             .disposed(by: disposeBag)
    }


    @objc
    private func rightButtonTapped() {
        
        let mapVC = MapViewController(
            lat: viewModel.output.list.value.lat ?? "",
            lng: viewModel.output.list.value.lng ?? "",
            hospitalTitle: viewModel.output.list.value.centerName ?? ""
        )

        navigationController?.pushViewController(mapVC, animated: true)
    }

   
}

extension DetailViewController{
    private func setup(){
        view.backgroundColor = UIColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1)

        navigationController?.navigationBar.topItem?.title = ""

        let rightItem = UIBarButtonItem(title: "지도", style: .plain, target: self, action: #selector(rightButtonTapped))
        navigationItem.setRightBarButton(rightItem, animated: true)
    }
    private func drawView(centerData: String?, facilityNameData: String?, callData: String?, updatedAtData: String?, locationData: String?) {
        let centerView = DetailInfoView().then {
            $0.imageView.image = UIImage(named: "hospital")
            $0.nameLabel.text = "센터명"
            $0.dataLabel.text = centerData
            $0.backgroundColor = .white
        }
        let facilityNameView = DetailInfoView().then {
            $0.imageView.image = UIImage(named: "building")
            $0.nameLabel.text = "센터명"
            $0.dataLabel.text = facilityNameData
            $0.backgroundColor = .white
        }
        let callView = DetailInfoView().then {
            $0.imageView.image = UIImage(named: "telephone")
            $0.nameLabel.text = "센터명"
            $0.dataLabel.text = callData
            $0.backgroundColor = .white
        }
        let updatedAtView = DetailInfoView().then {
            $0.imageView.image = UIImage(named: "chat")
            $0.nameLabel.text = "센터명"
            $0.dataLabel.text = updatedAtData
            $0.backgroundColor = .white
        }
        let locationView = DetailInfoView().then {
            $0.imageView.image = UIImage(named: "placeholder")
            $0.nameLabel.text = "센터명"
            $0.dataLabel.text = locationData
            $0.backgroundColor = .white
        }

        view.addSubview(centerView)
        view.addSubview(facilityNameView)
        view.addSubview(callView)
        view.addSubview(updatedAtView)
        view.addSubview(locationView)

        centerView.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(200)
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
        }
        facilityNameView.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(200)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
        }

        callView.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(200)
            $0.left.equalToSuperview().offset(15)
            $0.top.equalTo(centerView.snp.bottom).offset(15)
        }

        updatedAtView.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(200)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(centerView.snp.bottom).offset(15)
        }
        locationView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.height.equalTo(200)
            $0.top.equalTo(callView.snp.bottom).offset(15)
        }
    }
}
