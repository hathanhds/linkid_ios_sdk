//
//  HomeViewController.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//  Copyright (c) 2024 All rights reserved.
//

import UIKit
import SkeletonView
import RxSwift
import iCarousel

class HomeViewController: BaseViewController, ViewControllerType {

    typealias ViewModel = HomeViewModel

    static func create(with navigator: Navigator, viewModel: HomeViewModel) -> Self {
        let vc = UIStoryboard.home.instantiateViewController(ofType: HomeViewController.self)
        vc.navigator = navigator
        vc.viewModel = viewModel
        return vc as! Self
    }

    // Header
    @IBOutlet weak var headerExpandedView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPointLabel: UILabel!
    @IBOutlet weak var icEyeImageView: UIImageView!


    @IBOutlet weak var headerUserPointLabel: UILabel!
    @IBOutlet weak var headerIcEyeImageView: UIImageView!
    @IBOutlet weak var headerCollapsedView: UIView!
    @IBOutlet weak var floatingHeaderView: UIView!
    @IBOutlet weak var expiredPointLabel: UILabel!


    // Content
    @IBOutlet weak var scrollView: UIScrollView!

    // Gift cate
    @IBOutlet weak var giftCateContainerView: UIView!
    @IBOutlet weak var giftCateCollectionView: UICollectionView!
    @IBOutlet weak var giftCateTitleLabel: UILabel!
    @IBOutlet weak var giftCateSeeMoreButton: UIButton!

    @IBOutlet weak var indicatorLeaderConstraint: NSLayoutConstraint!

    // Install app babber
    @IBOutlet weak var installAppBannerView: UIView!

    // News banner
    @IBOutlet weak var newsBannerContainerView: UIView!
    @IBOutlet weak var newsBannerCarousel: iCarousel!
    @IBOutlet weak var bannerPageControl: UIPageControl!

    // Gift group
    @IBOutlet weak var giftGroupContainerView: UIView!
    @IBOutlet weak var giftGroupCollectionView: UICollectionView!
    @IBOutlet weak var giftGroupCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var giftGroupTitleLabel: UILabel!
    @IBOutlet weak var giftGroupSeeMoreButton: UIButton!

    // News
    @IBOutlet weak var newsContainerView: UIView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsSeeMoreButton: UIButton!


    var viewModel: HomeViewModel!
    let giftGroupItemHeight = 170
    let hidePointText = "******"

    // MARK: - Life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSkeleton()
        viewModel.input.viewDidLoad.onNext(())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavigationBar(animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.showNavigationBar(animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.headerCollapsedView.setCommonGradient()
    }

    override func initView() {
        // Init nib view
        giftCateCollectionView.registerCellFromNib(ofType: GiftCategoryCollectionViewCell.self)
        giftGroupCollectionView.registerCellFromNib(ofType: GiftCollectionViewCell.self)

        // Header
        self.avatarImageView.image = .imgAvatarDefault
        self.icEyeImageView.image = .icHomeEyeOff
        self.userPointLabel.text = hidePointText
        self.headerUserPointLabel.text = hidePointText

        // Carousel
        setUpCarousel()

        // Scroll view
        scrollView.addPullToRefresh(target: self, action: #selector(onRefresh), topOffset: 48)
    }

    override func bindToView() {

        // Refeshing
        viewModel.output.isRefreshing.subscribe { [weak self] isRefreshing in
            guard let self = self else { return }
            self.scrollView.endRefreshing()
        }.disposed(by: disposeBag)

        // User info
        viewModel.output.isLoadingUserInfo.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (isLoading) {
                self.avatarImageView.addIndicator()
                self.avatarImageView.showIndicator()
            } else {
                let userInfo = viewModel.output.userInfo.value
                self.avatarImageView.hideIndicator()

                self.avatarImageView.setSDImage(with: userInfo?.avatar, placeholderImage: .imgAvatarDefault)
                self.userNameLabel.text = userInfo?.name ?? userInfo?.phoneNumber

            }
        })
            .disposed(by: disposeBag)

        viewModel.output.isShowCoin.subscribe(onNext: { [weak self] isShowCoin in
            guard let self = self else { return }
            if (isShowCoin) {
                let userInfo = viewModel.output.userInfo.value
                let pointFormatterString = Double(userInfo?.tokenBalance ?? 0).formatter()
                self.userPointLabel.text = pointFormatterString
                self.headerUserPointLabel.text = pointFormatterString

                self.icEyeImageView.image = .icHomeEyeOpen
                self.headerIcEyeImageView.image = .icHomeEyeOpen

                self.expiredPointLabel.isHidden = false
            } else {
                self.icEyeImageView.image = .icHomeEyeOff
                self.headerIcEyeImageView.image = .icHomeEyeOff

                self.userPointLabel.text = hidePointText
                self.headerUserPointLabel.text = hidePointText

                self.expiredPointLabel.isHidden = true
            }
        })
            .disposed(by: disposeBag)

        // User point
        viewModel.output.userPoint.subscribe(onNext: { [weak self] userPoint in
            guard let self = self else { return }
            // TODO: (thanh) test điểm hết hạn có đúng format k?
            let expiringTokenAmount = Double(userPoint?.expiringTokenAmount ?? 0)
            let expiringDateFormatter = Date.init(fromString: userPoint?.expiringDate ?? "", formatter: .yyyyMMdd)?.toString(formatter: .ddMMyyyy) ?? ""
            let isShowCoin = viewModel.output.isShowCoin.value
            if (expiringTokenAmount > 0 && isShowCoin) {
                self.expiredPointLabel.text = "\(expiringTokenAmount.formatter()) điểm sẽ hết hạn vào \(expiringDateFormatter)"
            } else {
                self.expiredPointLabel.text = ""
            }
        })
            .disposed(by: disposeBag)

        // Gift cates
        viewModel.output.isLoadingGiftCates.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            let giftCates = viewModel.output.giftCates.value
            if (!isLoading) {
                self.hideGiftCateLoading()
                self.giftCateContainerView.isHidden = giftCates.isEmpty
            }
            self.giftCateCollectionView.reloadData()
        })
            .disposed(by: disposeBag)


        // News and banner

        viewModel.output.isLoadingNewsAndBanner.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (!isLoading) {
                let banners = self.viewModel.output.banners.value
                let news = self.viewModel.output.news.value

                let numberOfPages = banners.count
                self.bannerPageControl.numberOfPages = numberOfPages
                self.bannerPageControl.isHidden = banners.isEmpty

                self.newsBannerContainerView.isHidden = banners.isEmpty
                self.newsContainerView.isHidden = news.isEmpty

                // hide loading
                self.hideNewsBannerLoading()
                self.hideNewsLoading()
            }
            self.newsBannerCarousel.reloadData()
            self.newsCollectionView.reloadData()
        })
            .disposed(by: disposeBag)


        viewModel.output.currentBannerPageControlIndex.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.bannerPageControl.currentPage = index
        })
            .disposed(by: disposeBag)


        // Gift group

        viewModel.output.isLoadingGiftGroup.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if (!isLoading) {
                let giftGroupInfo = self.viewModel.output.giftGroupInfo.value
                self.giftGroupTitleLabel.text = giftGroupInfo?.giftGroup?.name

                self.giftGroupContainerView.isHidden = (giftGroupInfo?.gifts ?? []).isEmpty

                self.hideGiftGroupLoading()
            }
            self.giftGroupCollectionView.reloadData()
        })
            .disposed(by: disposeBag)

    }



    func setUpCarousel() {
//        newsBannerCarousel.delegate = self
//        newsBannerCarousel.dataSource = self
        newsBannerCarousel.type = .linear
        newsBannerCarousel.scrollToItem(at: 0, animated: true)
        newsBannerCarousel.isPagingEnabled = true
        // Auto scroll
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.handleTimer), userInfo: nil, repeats: true)

        bannerPageControl.currentPageIndicatorTintColor = .mainColor
        bannerPageControl.pageIndicatorTintColor = .black.withAlphaComponent(0.6)
    }

    @objc func handleTimer() {
        var newIndex = newsBannerCarousel.currentItemIndex + 1
        if newIndex > newsBannerCarousel.numberOfItems {
            newIndex = 0
        }
        newsBannerCarousel.scrollToItem(at: newIndex, duration: 0.5)
    }

    @objc func swipeCarouselRight(sender: UISwipeGestureRecognizer) { newsBannerCarousel.scroll(byNumberOfItems: -1, duration: 0.1) }

    @objc func onRefresh() {
        self.viewModel.input.refreshData.onNext(())
    }


    // MARK: - Action

    @IBAction func searchAction(_ sender: Any) {
        self.navigator.show(segue: .listGiftByGroup(groupName: "Ưu đãi group", groupCode: "")) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func viewPointAction(_ sender: Any) {
        self.viewModel.input.onShowOrHideCoin.onNext(())
    }


    @IBAction func openEarnPointTipsAction(_ sender: Any) {

    }


    @IBAction func topupPhoneAction(_ sender: Any) {
    }

    @IBAction func openGiftCateAction(_ sender: Any) {
        self.navigator.show(segue: .allGifts) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


    @IBAction func openGiftGroupListAction(_ sender: Any) {
        let giftGroup = viewModel.output.giftGroupInfo.value?.giftGroup
        self.navigator.show(segue: .listGiftByGroup(groupName: giftGroup?.name ?? "Danh sách ưu đãi", groupCode: giftGroup?.code ?? "")) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func openNewsListAction(_ sender: Any) {

    }

    @IBAction func openContactCenterAction(_ sender: Any) {

    }
}

extension HomeViewController: UIScrollViewDelegate {


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.giftCateCollectionView == scrollView) {
            let minX: CGFloat = 0
            let maxX = scrollView.contentSize.width - scrollView.bounds.width
            let currentX = min(max(scrollView.contentOffset.x, minX), maxX)

            let indicatorWidth = 25.0

            let scale = indicatorWidth / scrollView.contentSize.width
            self.indicatorLeaderConstraint.constant = currentX * scale
        } else {
            let shrinkOffset = self.scrollView.contentOffset.y
            let headerCollapseViewBottom = self.headerCollapsedView.frame.origin.y + self.headerCollapsedView.frame.size.height
            let headerExpandViewBottom = self.headerExpandedView.frame.origin.y + self.headerExpandedView.frame.size.height
            let alpha: CGFloat = {
                let _alpha = (headerExpandViewBottom - shrinkOffset) / headerExpandViewBottom
                return _alpha
            }()

            self.headerExpandedView.alpha = alpha
            self.floatingHeaderView.alpha = alpha

            self.headerCollapsedView.alpha = 1 - alpha + 0.5
            let isCollapseHeader = shrinkOffset < headerCollapseViewBottom
            self.headerCollapsedView.isHidden = isCollapseHeader
        }
    }
}

extension HomeViewController: SkeletonCollectionViewDataSource, SkeletonCollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Datasource

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        switch skeletonView {
        case self.giftCateCollectionView:
            return String(describing: GiftCategoryCollectionViewCell.self)
        case self.giftGroupCollectionView:
            return String(describing: GiftCollectionViewCell.self)
        case self.newsCollectionView:
            return String(describing: HomeNewsCollectionViewCell.self)
        default:
            return ""
        }
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.giftCateCollectionView:
            return self.viewModel.output.giftCates.value.count
        case self.giftGroupCollectionView:
            return self.viewModel.output.giftGroupInfo.value?.numberOfGifts ?? 0
        case self.newsCollectionView:
            return self.viewModel.output.news.value.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.giftCateCollectionView:
            let cell = collectionView.dequeueCell(ofType: GiftCategoryCollectionViewCell.self, for: indexPath)
            let category = viewModel.output.giftCates.value[indexPath.row]
            cell.setDataForCell(cate: category)
            return cell
        case self.giftGroupCollectionView:
            let cell = collectionView.dequeueCell(ofType: GiftCollectionViewCell.self, for: indexPath)
            let gift = (viewModel.output.giftGroupInfo.value?.gifts ?? [])[indexPath.row]
            cell.setDataForCell(gift: gift)
            return cell
        case self.newsCollectionView:
            let cell = collectionView.dequeueCell(ofType: HomeNewsCollectionViewCell.self, for: indexPath)
            let new = viewModel.output.news.value[indexPath.row]
            cell.titleLabel.text = new.article?.name
            cell.imageView.setSDImage(with: new.article?.linkAvatar)
            cell.titleLabel.numberOfLines = 2
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    // MARK: - Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = viewModel.output.giftCates.value[indexPath.row]
        self.navigator.show(segue: .listGiftByCate(cate: category)) { [weak self] vc in
            guard let self = self else { return }
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }

    // MARK: - Flow layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let padding = 16.0
        switch collectionView {
        case giftCateCollectionView:
            let height = collectionView.frame.height
            return CGSize (width: 80, height: height)
        case giftGroupCollectionView:
            let numberItemsPerRow = 2.0
            let width = (collectionView.frame.width - padding * 3) / numberItemsPerRow
            let totalGift = self.viewModel.output.giftGroupInfo.value?.numberOfGifts ?? 0
            let numberOfRow: Int = {
                if (totalGift % 2 == 0) {
                    return totalGift / 2
                }
                return totalGift / 2 + 1
            }()
            let collectionViewHeight = numberOfRow * giftGroupItemHeight
            self.giftGroupCollectionViewHeightConstraint.constant = CGFloat(collectionViewHeight)
            return CGSize(width: width, height: CGFloat(giftGroupItemHeight))
        case newsCollectionView:
            let width = (collectionView.frame.width - padding) / 1.5
            return CGSize(width: width, height: 176.0)

        default:
            return collectionView.bounds.size
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16.0, bottom: 0, right: 16.0)
    }


}

//extension HomeViewController: iCarouselDataSource, iCarouselDelegate {
//
//    // MARK: - iCarousel Datasource
//
//    func numberOfItems(in carousel: iCarousel) -> Int {
//        return self.viewModel.output.banners.value.count
//    }
//
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        let imageView: UIImageView
//
//        if view != nil {
//            imageView = view as! UIImageView
//        } else {
//            imageView = UIImageView(frame: self.newsBannerCarousel.frame)
//        }
//
//        let banners = self.viewModel.output.banners.value
//
//        imageView.setSDImage(with: banners[index].article?.linkAvatar)
//        imageView.layer.cornerRadius = 12.0
//        imageView.layer.masksToBounds = true
//
//        return imageView
//    }
//
//    // MARK: - iCarousel Delegate
//
//
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        switch (option) {
//        case .spacing:
//            return value * 1.05
//        case .visibleItems:
//            return 3.0
//        case .wrap:
//            return 1
//        default:
//            return value
//        }
//    }
//
//    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
//        // TODO: - hanlde open news detail
//    }
//
//    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
//        self.viewModel.output.currentBannerPageControlIndex.accept(carousel.currentItemIndex)
//    }
//}

extension HomeViewController {
    func setUpSkeleton () {
        showGiftCateLoading()
        showNewsBannerLoading()
        showGiftGroupLoading()
        showNewsLoading()
    }

    func showGiftCateLoading() {
        self.giftCateCollectionView.showSkeletonView()
//        self.giftCateTitleLabel.showSkeletonView()
        self.giftCateSeeMoreButton.isHidden = true
    }

    func hideGiftCateLoading() {
        self.giftCateCollectionView.hideSkeleton()
//        self.giftCateTitleLabel.hideSkeleton()
        self.giftCateSeeMoreButton.isHidden = false
    }

    func showNewsBannerLoading() {
        self.newsBannerCarousel.showSkeletonView()
        self.bannerPageControl.isHidden = true
    }

    func hideNewsBannerLoading() {
        self.newsBannerCarousel.hideSkeleton()
    }

    func showGiftGroupLoading() {
        self.giftGroupCollectionView.showSkeletonView()
        self.giftGroupTitleLabel.showSkeletonView()
        self.giftGroupTitleLabel.numberOfLines = 1
        self.giftGroupSeeMoreButton.isHidden = true
    }

    func hideGiftGroupLoading() {
        self.giftGroupCollectionView.hideSkeleton()
        self.giftGroupTitleLabel.hideSkeleton()
        self.giftGroupSeeMoreButton.isHidden = false
    }

    func showNewsLoading() {
        self.newsCollectionView.showSkeletonView()
        self.newsTitleLabel.showSkeletonView()
        self.newsSeeMoreButton.isHidden = true
    }

    func hideNewsLoading() {
        self.newsCollectionView.hideSkeleton()
        self.newsTitleLabel.hideSkeleton()
        self.newsTitleLabel.isHidden = false
    }
}
