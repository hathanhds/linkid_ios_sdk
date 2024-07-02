//
//  Navigator.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 15/01/2024.
//

import UIKit


class Navigator {

    enum Segue {
        case main
        case launchScreen
        case termsAndPolivy(type: TermsAndPolicyType)
        case accountExistAndConnected
        case accountNotExistAndConnected
        case accountExistAndNotConnected
        case accountNotExistAndNotConnected
        case authenConnectedPhoneNumber
        case popup (dismissable: Bool = true, type: PopupType, title: String, message: String, image: UIImage, confirmnButton: PopupViewModel.ConfirmButton? = nil, cancelButton: PopupViewModel.CancelButton? = nil)
        case allGifts
        case listGiftByCate(cate: GiftCategory)
        case listDiamondGiftByCate(cate: GiftCategory)
        case listGiftByGroup(groupName: String?, groupCode: String)
        case giftFilter(filterModel: GiftFilterModel?, applyFilterAction: GiftFilterViewModel.ApplyFilterActionType?)
        case error
        case anonymous
        case installAppPopup
        case egiftRewardDetail(giftInfo: GiftInfoItem, giftTransactionCode: String)
        case physicalRewardDetail(giftInfo: GiftInfoItem, giftTransactionCode: String)
        case myrewardFilter(myRewardType: MyRewardType, filterModel: MyrewardFilterModel?, applyFilterAction: MyRewardFilterViewModel.ApplyFilterActionType?)
        case giftLocation(giftCode: String)
        case markUsed(didFinish: () -> Void)
        case giftDetail(giftId: String)
        case giftDetailDiamond(giftInfo: GiftInfor)
        case search
        case popupDiamondFilter(dismissable: Bool = true, selectedOption: GiftSorting = .popular, closeButtonAction: PopupDiamondFilterViewModel.CloseButton? = nil, applyButtonAction: PopupDiamondFilterViewModel.ApplyButton? = nil, selectMostPopularOptionAction: PopupDiamondFilterViewModel.SelectMostPopularButton? = nil, selectCheapestOptionAction: PopupDiamondFilterViewModel.SelectCheapestButton? = nil)
        case transactionDetail(tokenTransID: String? = nil, orderCode: String? = nil)
        case giftExchangeConfirm(data: GiftConfirmExchangeArguments)
        case giftExchangeSuccess(giftInfo: GiftInfoItem, transactionInfo: CreateTransactionItem, quantiry: Int)
        case physicalShipping(giftInfo: GiftInfoItem, giftExchangePrice: Double, receiverInfoModel: ReceiverInfoModel? = nil)
        case shippingLocation(data: ShippingLocationArguments)
        case otp(data: OTPArguments)
    }

    public func show(segue: Segue, withAction action: (_ vc: UIViewController) -> Void) {
        var vc: UIViewController!
        switch segue {
            // MARK: - Main
        case .main:
            let vm = MainTabBarViewModel()
            vc = MainTabBarController.create(with: self, viewModel: vm)
        case .launchScreen:
            let vm = LaunchScreenViewModel(authenRepository: AuthRepositoryImp())
            vc = LaunchScreenViewController.create(with: self, viewModel: vm)
        case .termsAndPolivy(let type):
            let vm = TermsAndPolicyViewModel(type: type, authRepository: AuthRepositoryImp())
            vc = TermsAndPolicyViewController.create(with: self, viewModel: vm)
        case .accountExistAndConnected:
            let vm = AccountExistAndConnectedViewModel()
            vc = AccountExistAndConnectedViewController.create(with: self, viewModel: vm)
        case .accountNotExistAndConnected:
            let vm = AccountNotExistAndConnectedViewModel(authenRepository: AuthRepositoryImp())
            vc = AccountNotExistAndConnectedViewController.create(with: self, viewModel: vm)
        case .accountExistAndNotConnected:
            let vm = AccountExistAndNotConnectedViewModel()
            vc = AccountExistAndNotConnectedViewController.create(with: self, viewModel: vm)
        case .accountNotExistAndNotConnected:
            let vm = AccountNotExistAndNotConnectedViewModel(authenRepository: AuthRepositoryImp())
            vc = AccountNotExistAndNotConnectedViewController.create(with: self, viewModel: vm)
        case .authenConnectedPhoneNumber:
            let vm = AuthenConnectedPhoneNumberViewModel(authRepository: AuthRepositoryImp())
            vc = AuthenConnectedPhoneNumberViewController.create(with: self, viewModel: vm)
        case .popup(let dismissable, let type, let title, let message, let image, let confirmnButton, let cancelButton):
            let vm = PopupViewModel(dismissable: dismissable, type: type, title: title, message: message, image: image, confirmnButton: confirmnButton, cancelButton: cancelButton)
            vc = PopupViewController.create(with: self, viewModel: vm)
        case .allGifts:
            let vm = AllGiftsViewModel(giftsRepository: GiftsRepositoryImpl())
            vc = AllGiftsViewController.create(with: self, viewModel: vm)
        case .listDiamondGiftByCate(let cate):
            let vm = ListDiamondGiftByCateViewModel(giftsRepository: GiftsRepositoryImpl(), userRepository: UserRepositoryImpl(), cate: cate)
            vc = ListDiamondGiftByCateViewController.create(with: self, viewModel: vm)
        case .listGiftByCate(let cate):
            let vm = ListGiftByCateViewModel(giftsRepository: GiftsRepositoryImpl(), userRepository: UserRepositoryImpl(), cate: cate)
            vc = ListGiftByCateViewController.create(with: self, viewModel: vm)
        case .listGiftByGroup(let groupName, let groupCode):
            let vm = ListGiftByGroupViewModel(giftsRepository: GiftsRepositoryImpl(), groupName: groupName, groupCode: groupCode)
            vc = ListGiftByGroupViewController.create(with: self, viewModel: vm)
        case .giftFilter(let filterModel, let applyFilterAction):
            let vm = GiftFilterViewModel(filterModel: filterModel, applyFilterAction: applyFilterAction)
            vc = GiftFilterViewController.create(with: self, viewModel: vm)
        case .error:
            let vm = ErrorViewModel()
            vc = ErrorViewController.create(with: self, viewModel: vm)
        case .anonymous:
            let vm = AnonymousViewModel()
            vc = AnonymousViewController.create(with: self, viewModel: vm)
        case .installAppPopup:
            let vm = InstallAppPopupViewModel()
            vc = InstallAppPopupViewController.create(with: self, viewModel: vm)
        case .egiftRewardDetail(let giftInfo, let giftTransactionCode):
            let vm = EgiftRewardDetailViewModel(myRewardRepository: MyrewardRepositoryImpl(), giftTransactionCode: giftTransactionCode, giftInfo: giftInfo)
            vc = EgiftRewardDetailViewController.create(with: self, viewModel: vm)
        case .physicalRewardDetail(_, let giftTransactionCode):
            let vm = PhysicalRewardDetailViewModel(myRewardRepository: MyrewardRepositoryImpl(), userRepository: UserRepositoryImpl(), giftTransactionCode: giftTransactionCode)
            vc = PhysicalRewardDetailViewController.create(with: self, viewModel: vm)
        case .myrewardFilter(let myRewardType, let filterModel, let applyFilterAction):
            let vm = MyRewardFilterViewModel(filterModel: filterModel, applyFilterAction: applyFilterAction, myRewardType: myRewardType)
            vc = MyRewardFilterViewController.create(with: self, viewModel: vm)
        case .giftLocation(let giftCode):
            let vm = GiftLocationViewModel(giftsRepository: GiftsRepositoryImpl(), giftCode: giftCode)
            vc = GiftLocationViewController.create(with: self, viewModel: vm)
        case .markUsed(let didFinish):
            let vm = MarkUsedViewModel(didFinish: didFinish)
            vc = MarkUsedViewController.create(with: self, viewModel: vm)
        case .giftDetail(let giftId):
            let vm = GiftDetailViewModel(giftsRepository: GiftsRepositoryImpl(), giftId: giftId)
            vc = GiftDetailViewController.create(with: self, viewModel: vm)
        case .search:
            let vm = GiftSearchViewModel(giftsRepository: GiftsRepositoryImpl(), userRepository: UserRepositoryImpl())
            vc = GiftSearchViewController.create(with: self, viewModel: vm)
            break
        case .transactionDetail(let tokenTransID, let orderCode):
            let vm = TransactionHistoryDetailModel(tokenTransID: tokenTransID, orderCode: orderCode, transactionRepository: ListTransactionRepositoryImp())
            vc = TransactionHistoryDetailViewController.create(with: self, viewModel: vm)

        case .popupDiamondFilter(let dismissable, let selectedOption, let closeButtonAction, let applyButtonAction, let selectMostPopularOptionAction, let selectCheapestOptionAction):
            let vm = PopupDiamondFilterViewModel(dismissable: dismissable,
                selectedOption: selectedOption,
                closeButtonAction: closeButtonAction,
                applyButtonAction: applyButtonAction,
                selectMostPopularOptionAction: selectMostPopularOptionAction,
                selectCheapestOptionAction: selectCheapestOptionAction)
            vc = PopupDiamondFilterViewController.create(with: self, viewModel: vm)
        case .giftExchangeConfirm(let data):
            let vm = GiftConfirmExchangeViewModel(
                data: GiftConfirmExchangeArguments(giftsRepository: data.giftsRepository,
                    giftInfo: data.giftInfo,
                    giftExchangePrice: data.giftExchangePrice,
                    receiverInfo: data.receiverInfo
                ))
            vc = GiftConfirmExchangeViewController.create(with: self, viewModel: vm)
        case .giftExchangeSuccess(let giftInfo, let transactionInfo, let quantiry):
            let vm = GiftExchangeSuccessViewModel(giftInfo: giftInfo, transactionInfo: transactionInfo, quantiry: quantiry)
            vc = GiftExchangeSuccessViewController.create(with: self, viewModel: vm)
        case .physicalShipping(let giftInfo, let giftExchangePrice, let receiverInfoModel):
            let vm = PhysicalShippingViewModel(userRepository: UserRepositoryImpl(),
                giftInfo: giftInfo,
                giftExchangePrice: giftExchangePrice,
                receiverInfoModel: receiverInfoModel)
            vc = PhysicalShippingViewController.create(with: self, viewModel: vm)
        case .shippingLocation(let data):
            let vm = ShippingLocationViewModel(data: data)
            vc = ShippingLocationViewController.create(with: self, viewModel: vm)
        case .otp(let data):
            let vm = OTPViewModel(data: data)
            vc = OTPViewController.create(with: self, viewModel: vm)
        case .giftDetailDiamond(let giftInfo):
            let vm = GiftDetailDiamondViewModel(giftsRepository: GiftsRepositoryImpl(), giftInfo: giftInfo)
            vc = GiftDetailDiamondViewController.create(with: self, viewModel: vm)
        default:
            break
        }
        vc.hidesBottomBarWhenPushed = true
        action(vc)

    }
}
