//
//  ListCustomCell.swift
//  Covid
//
//  Created by Jay on 2022/01/13.
//

import SnapKit
import UIKit

final class ListCustomCell: UITableViewCell {

    override init(style _: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
        super.init(style: .default, reuseIdentifier: "ListCustomCell")
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var centerNameData = UILabel().then{
        $0.textAlignment = .left
    }
    var facilityNameData = UILabel().then{
        $0.textAlignment = .left
    }
    var addressData = UILabel().then{
        $0.textAlignment = .left
    }
    var updatedAtData = UILabel().then{
        $0.textAlignment = .left
    }

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell() {
        let centerNameLabel = UILabel().then {
            $0.text = "센터명"
            $0.textColor = .lightGray
            $0.textAlignment = .left
        }

        let facilityNameLabel = UILabel().then {
            $0.text = "건물명"
            $0.textColor = .lightGray
            $0.textAlignment = .left
        }

        let addressLabel = UILabel().then {
            $0.text = "주소"
            $0.textColor = .lightGray
            $0.textAlignment = .left
        }

        let updatedAtLabel = UILabel().then {
            $0.text = "업데이트 시간"
            $0.textColor = .lightGray
            $0.textAlignment = .left
        }

        addSubview(centerNameLabel)
        addSubview(facilityNameLabel)
        addSubview(addressLabel)
        addSubview(updatedAtLabel)

        addSubview(centerNameData)
        addSubview(facilityNameData)
        addSubview(addressData)
        addSubview(updatedAtData)

        centerNameLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(10)
            $0.width.equalTo(120)
            $0.height.equalTo(17)
        }

        facilityNameLabel.snp.makeConstraints {
            $0.left.equalTo(centerNameLabel)
            $0.top.equalTo(centerNameLabel.snp.bottom).offset(15)
            $0.width.equalTo(120)
            $0.height.equalTo(17)
        }

        addressLabel.snp.makeConstraints {
            $0.left.equalTo(centerNameLabel)
            $0.top.equalTo(facilityNameLabel.snp.bottom).offset(15)
            $0.width.equalTo(120)
            $0.height.equalTo(17)
        }

        updatedAtLabel.snp.makeConstraints {
            $0.left.equalTo(centerNameLabel)
            $0.top.equalTo(addressLabel.snp.bottom).offset(15)
            $0.width.equalTo(120)
            $0.height.equalTo(17)
        }

        centerNameData.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalTo(centerNameLabel.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(17)
        }

        facilityNameData.snp.makeConstraints {
            $0.top.equalTo(centerNameData.snp.bottom).offset(15)
            $0.left.equalTo(facilityNameLabel.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(17)
        }

        addressData.snp.makeConstraints {
            $0.top.equalTo(facilityNameData.snp.bottom).offset(15)
            $0.left.equalTo(addressLabel.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(17)
        }

        updatedAtData.snp.makeConstraints {
            $0.top.equalTo(addressData.snp.bottom).offset(15)
            $0.left.equalTo(updatedAtLabel.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(17)
        }
    }
}
