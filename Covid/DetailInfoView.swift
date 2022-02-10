//
//  DetailInfoView.swift
//  Covid
//
//  Created by Jay on 2022/01/14.
//

import UIKit
import SnapKit

final class DetailInfoView: UIView {
    
    let imageView = UIImageView().then {
        $0.backgroundColor = .white
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 13)
        $0.sizeToFit()
    }
    
    let dataLabel = UILabel().then {
        $0.textColor = .black
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 11)
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension DetailInfoView{
    private func setup() {
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8

        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 10, height: 10)
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor

        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(dataLabel)

        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }

        nameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(17)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(20)
        }

        dataLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(17)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }
}
