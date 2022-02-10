//
//  CenterModel.swift
//  Covid
//
//  Created by JK on 2022/01/14.
//

import Foundation

struct CenterModel: Decodable {
    let centerName: String?
    let facilityName: String?
    let address: String?
    let updatedAt: String?
    let phoneNumber: String?
    let lat: String?
    let lng: String?
}
