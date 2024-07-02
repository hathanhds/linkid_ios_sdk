//
//  TransactionHistoryChildViewController.swift
//  LinkIDApp
//
//  Created by Phan Tuan Anh on 31/05/2024.
//

import UIKit

class TransactionHistoryChildViewController: BaseViewController {
    class func create(with navigator: Navigator, viewModel: TransactionHistoryChildModel) -> Self {
        let vc = UIStoryboard.transactionHistory.instantiateViewController(ofType: TransactionHistoryChildViewController.self)
        vc.viewModel = viewModel
        vc.navigator = navigator
        return vc as! Self
    }

    @IBOutlet weak var _tableView: UITableView!
    @IBOutlet var _tableEmptyView: UIView!

    var viewModel: TransactionHistoryChildModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let v = self._tableView.refreshControl, v.isRefreshing {
            v.endRefreshing()
            v.beginRefreshing()
            self._tableView.contentOffset = CGPoint(x: 0, y: -(v.bounds.height))
        }
    }

    @objc func onRefresh() {
        viewModel.input.refreshData.onNext(())
    }

    override func initView() {
        _tableView.register(cellType: TransactionItemTableViewCell.self)
        _tableView.addPullToRefresh(target: self, action: #selector(self.onRefresh))
    }

    override func bindToView() {
        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self._tableView.endRefreshing()
        }.disposed(by: disposeBag)

        // Loading
        viewModel.output.isLoading.subscribe (onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.showLoading()
            } else {
                self.hideLoading()
            }
            self.reloadTableView()
        })
            .disposed(by: disposeBag)

        // LoadMore
        viewModel.output.isLoadMore
            .subscribe(onNext: { [weak self] isLoadMore in
            guard let self = self else { return }
            if isLoadMore {
                self._tableView.addBottomLoadingView()
            } else {
                self._tableView.removeBottomLoadingView()
            }
        }).disposed(by: disposeBag)
    }

    func reloadTableView() {
        if UserDefaults.standard.data(forKey: Constant.kAllMerchant) != nil {
            _tableView.reloadData()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.reloadTableView()
            }
        }
    }
}

extension TransactionHistoryChildViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: - Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = viewModel.output.listTransaction.value.count // Assume items is your data source array
        _tableView.backgroundView = (viewModel.output.isLoading.value == false && itemCount == 0) ? _tableEmptyView: nil
        return itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: TransactionItemTableViewCell.self, for: indexPath)
        let transaction = viewModel.output.listTransaction.value[indexPath.row]
        cell.selectionStyle = .none
        cell.setDataForCell(item: transaction)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLoadMore = viewModel.output.isLoadMore.value
        let currentGifts = viewModel.output.listTransaction.value
        if indexPath.row == currentGifts.count - 1,
            currentGifts.count < viewModel.totalCount,
            !isLoadMore {
            viewModel.onLoadMore()
        }
    }

    // MARK: - Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: pta - Open transaction detail screen
        let transaction = viewModel.output.listTransaction.value[indexPath.row]
        self.navigator.show(segue: .transactionDetail(tokenTransID: transaction.tokenTransID)) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }


    }
}
