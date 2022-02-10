//
//  ListViewModel.swift
//  Covid
//
//  Created by Jay on 2022/01/13.
//
//
import Alamofire
import Foundation
import RxRelay
import RxSwift


protocol ListViewModelType {
  var input: ListViewModelInput { get }
  var output: ListViewModelOutput { get }
}


protocol ListViewModelInput {
  func requestApi()
}


protocol ListViewModelOutput {
  var list: BehaviorRelay<ListModel> { get }
}


final class ListViewModel: ListViewModelInput, ListViewModelOutput {
    private var pageNumber = 1
    var list = BehaviorRelay<ListModel>(value: ListModel(data: []))
    private let disposeBag = DisposeBag()
}

extension ListViewModel{
    
    func requestApi() {
      let urlString = "https://api.odcloud.kr/api/15077586/v1/centers?page=\(pageNumber)&perpage=1&serviceKey=bNmSjmL3NWL%2FmAmsQV0SyDT%2B8DCdZckhVg5%2FtSsmJHa47eBZBE%2BaFvCHYxeM1Dsz2FcgQ64elqYL3mr6GUyjOg%3D%3D"
      
        ListRequest.loadData(urlString: urlString)
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
        .flatMap { data -> Single<ListModel> in
          guard let listModel = try? JSONDecoder().decode(ListModel.self, from: data) else { return Single.error(NSError()) }
          return Single.just(listModel)
        }
        .map { ListModel(data: self.list.value.data + $0.data.sorted(by: { lhs, rhs in
          guard
            let lhs = self.stringToDateFormat(date: lhs.updatedAt ?? ""),
            let rhs = self.stringToDateFormat(date: rhs.updatedAt ?? "") else { return true }
          
          return lhs > rhs
        }))
        }
        .subscribe(onSuccess: { self.list.accept($0) })
        .disposed(by: disposeBag)
      
      self.pageNumber += 1
    }
    
    private func stringToDateFormat(date: String) -> Date? {
      let dateformatter = DateFormatter()
      dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      return dateformatter.date(from: date)
    }
}
extension ListViewModel: ListViewModelType {
  var input: ListViewModelInput { self }
  var output: ListViewModelOutput { self }
}
