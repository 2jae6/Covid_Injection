//
//  ListRequest.swift
//  Covid
//
//  Created by Jay on 2022/01/14.
//

import Foundation
import Alamofire
import RxSwift

final class ListRequest{
    private init(){ }
  
    static func loadData(urlString: String) -> Single<Data> {
        .create { subscriber in
        let request = AF.request(urlString, method: .get).responseData { response in
          if let data = response.data {
            subscriber(.success(data))
          } else {
            if let err = response.error {
              subscriber(.failure(err))
            }
          }
        }

        return Disposables.create { request.cancel() }
      }
    }
}
