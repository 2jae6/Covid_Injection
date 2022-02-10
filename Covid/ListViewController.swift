//
//  ViewController.swift
//  Covid
//
//  Created by Jay on 2022/01/13.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class ListViewController: UIViewController {
    
    init(with viewModel: ListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let viewModel: ListViewModelType
    private var listTableView = UITableView()
    private let disposeBag = DisposeBag()
    private let scrollToTopButton = UIButton()
    private var pageOn = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        drawListView()
        listTableView.register(ListCustomCell.self, forCellReuseIdentifier: "ListCustomCell")
        listTableView.rowHeight = 150

        drawTableView()
        bindToTableView()
        bindToButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "예방접종센터 리스트"
    }
    var str:String = ""

}

extension ListViewController {
    private func drawListView() {
        listTableView.backgroundColor = .white
        view.addSubview(listTableView)

        listTableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        scrollToTopButton.do {
            $0.setImage(UIImage(named: "top-alignment"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 25
            $0.layer.masksToBounds = true
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
            $0.backgroundColor = .white
            
        }

        view.addSubview(scrollToTopButton)

        scrollToTopButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.bottom.right.equalToSuperview().offset(-30)
        }
    }

    private func drawTableView() {
        viewModel.input.requestApi()

        viewModel.output.list
            .map { $0.data }
            .observe(on: MainScheduler.instance)
            .bind(to: listTableView.rx.items(cellIdentifier: "ListCustomCell", cellType: ListCustomCell.self)) {
                _, element, cell in

                cell.centerNameData.text = element.address
                cell.facilityNameData.text = element.facilityName
                cell.addressData.text = element.address
                cell.updatedAtData.text = element.updatedAt

            }.disposed(by: disposeBag)
    }

    private func bindToTableView() {
        listTableView.rx.itemSelected
            .withUnretained(self)
            .subscribe(onNext: { vc, indexPath in
                let data = vc.viewModel.output.list.value.data[indexPath.row]
                let viewModel = DetailViewModel()
                viewModel.input.setData(data: data)
                vc.listTableView.deselectRow(at: indexPath, animated: true)
                vc.navigationController?.pushViewController(DetailViewController(with: viewModel), animated: true)
            })
            .disposed(by: disposeBag)

        listTableView.rx.didScroll
            .withUnretained(self)
            .debounce(.milliseconds(50), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _, _ in
                
                let offSetY = self.listTableView.contentOffset.y
                let contentHeight = self.listTableView.contentSize.height

                if offSetY > (contentHeight - self.listTableView.bounds.height - 100) && offSetY > 0{
                    self.viewModel.input.requestApi()
                }
                
            })
            .disposed(by: disposeBag)
    }

    private func bindToButton() {
        scrollToTopButton.rx.tap
            .subscribe(onNext: {
                self.listTableView.setContentOffset(.zero, animated: true)
            }).disposed(by: disposeBag)
    }
    func test() {
    
        let textfield = UITextField()
        textfield.rx.text
            .orEmpty
            .bind(to: self.rx.str)
            .disposed(by: disposeBag)
    }
}
