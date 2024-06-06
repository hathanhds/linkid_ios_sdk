//
//  AnonymousViewModel.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 25/03/2024.
//

import Foundation

class AnonymousViewModel: ViewModelType {
    struct Input {

    }

    struct Output {

    }

    let input: Input
    let output: Output

    init() {
        self.input = Input()
        self.output = Output()
    }
}
