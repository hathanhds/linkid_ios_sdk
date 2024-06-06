//
//  GiftSearchViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 29/05/2024.
//

import UIKit
import RxSwift

class GiftSearchViewController: BaseViewController {

    class func create(with navigator: Navigator, viewModel: GiftSearchViewModel) -> Self {
        let vc = UIStoryboard.gifts.instantiateViewController(ofType: GiftSearchViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Outlets
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var sortImageView: UIImageView!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var icFilterImageView: UIImageView!
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var tableView: UITableView!

    // Variables
    var viewModel: GiftSearchViewModel!
    let hasData = true

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.viewDidLoad.onNext(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func initView() {
        tableView.tableFooterView = UIView()
        tableView.register(cellType: GiftTableViewCell.self)
        tableView.addPullToRefresh(target: self, action: #selector(self.onRefresh))
    }

    @objc func onRefresh() {
//        viewModel.input.refreshData.onNext(())
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func sortAction(_ sender: Any) {
    }

    @IBAction func filterAction(_ sender: Any) {
    }

}

extension GiftSearchViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 0
        }
        return 3
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0) {
            if (hasData) {
                return nil
            }
            let section = tableView.dequeueCell(ofType: GiftSearchEmptyTableViewCell.self)
            return section.contentView
        }
        let section = tableView.dequeueCell(ofType: GiftSectionTitleTableViewCell.self)
        section.setDataForCell(isShowSearchResult: hasData, title: hasData ? "38 kết quả" : "Gợi ý cho bạn")
        return section.contentView
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }


    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: GiftTableViewCell.self, for: indexPath)
//        let gift = viewModel.output.gifts.value[indexPath.row]
//        cell.setDataForCell(data: gift)
        return cell
    }
}

extension GiftSearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        floatingView.isHidden = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        floatingView.isHidden = false
    }
}

