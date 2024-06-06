//
//  GiftConfirmExchangeViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 31/05/2024.
//

import RxSwift
import RxCocoa

class GiftConfirmExchangeViewModel{
    let disposeBag = DisposeBag()
    
    private let giftsRepository: GiftsRepository
    
    struct Input {
        let viewDidLoad: AnyObserver<Void>

    }

    struct Output {
    
    }
    
    let input: Input
    let viewDidLoadSubj = PublishSubject<Void>()

    let output: Output
   
    
    init(giftsRepository: GiftsRepository) {
        self.giftsRepository = giftsRepository

        self.input = Input(viewDidLoad: viewDidLoadSubj.asObserver())
        self.output = Output()

        self.viewDidLoadSubj.subscribe { [weak self] _ in
            guard let self = self else { return }
           
        }.disposed(by: disposeBag)

    }
    
}


