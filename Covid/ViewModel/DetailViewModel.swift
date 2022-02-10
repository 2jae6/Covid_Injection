//
//  DetailViewModel.swift
//  Covid
//
//  Created by Jay on 2022/01/13.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift


protocol DetailViewModelType {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get }
}


protocol DetailViewModelInput {
    func setData(data: CenterModel)
}


protocol DetailViewModelOutput {
    var list: BehaviorRelay<CenterModel> { get }
}


final class DetailViewModel: DetailViewModelInput, DetailViewModelOutput {
    var list = BehaviorRelay<CenterModel>(value: CenterModel(centerName: nil, facilityName: nil, address: nil, updatedAt: nil, phoneNumber: nil, lat: nil, lng: nil))

    func setData(data: CenterModel) {
        list.accept(data)
    }
}


extension DetailViewModel: DetailViewModelType {
    var input: DetailViewModelInput { self }
    var output: DetailViewModelOutput { self }
}
