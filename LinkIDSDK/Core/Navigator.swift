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
        case listGiftByGroup(groupName: String?, groupCode: String)
        case giftFilter(filterModel: GiftFilterModel?, applyFilterAction: GiftFilterViewModel.ApplyFilterActionType?)
        case error
        case anonymous
        case installAppPopup
        case egiftRewardDetail(giftInfo: GiftInfoItem, giftTransactionCode: String)
        case physicalRewardDetail(giftInfo: GiftInfoItem, giftTransactionCode: String)
        case myrewardFilter(myRewardType: MyRewardType, filterModel: MyrewardFilterModel?, applyFilterAction: MyRewardFilterViewModel.ApplyFilterActionType?)
        case giftLocation
        case markUsed(didFinish: () -> Void)
        case giftDetail(giftId: String)
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
        case .egiftRewardDetail(_, let giftTransactionCode):
            let vm = EgiftRewardDetailViewModel(myRewardRepository: MyrewardRepositoryImpl(), giftTransactionCode: giftTransactionCode)
            vc = EgiftRewardDetailViewController.create(with: self, viewModel: vm)
        case .physicalRewardDetail(_, let giftTransactionCode):
            let vm = PhysicalRewardDetailViewModel(myRewardRepository: MyrewardRepositoryImpl(), giftTransactionCode: giftTransactionCode)
            vc = PhysicalRewardDetailViewController.create(with: self, viewModel: vm)
        case .myrewardFilter(let myRewardType, let filterModel, let applyFilterAction):
            let vm = MyRewardFilterViewModel(filterModel: filterModel, applyFilterAction: applyFilterAction, myRewardType: myRewardType)
            vc = MyRewardFilterViewController.create(with: self, viewModel: vm)
        case .giftLocation:
            let vm = GiftLocationViewModel()
            vc = GiftLocationViewController.create(with: self, viewModel: vm)
        case .markUsed(let didFinish):
            let vm = MarkUsedViewModel(didFinish: didFinish)
            vc = MarkUsedViewController.create(with: self, viewModel: vm)
        case .giftDetail(let giftId):
            let vm = GiftDetailViewModel(giftsRepository: GiftsRepositoryImpl(), giftId: giftId)
            vc = GiftDetailViewController.create(with: self, viewModel: vm)
        default:
            break
        }
        vc.hidesBottomBarWhenPushed = true
        action(vc)
    }

}
