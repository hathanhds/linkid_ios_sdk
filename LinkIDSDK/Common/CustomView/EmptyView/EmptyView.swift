//
//  EmptyView.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 01/03/2024.
//

import UIKit

class EmptyView: UIView, NibLoadable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    init(image: UIImage? = nil, title: String? = "Không tìm thấy kết quả") {
        super.init(frame: .zero)
        imageView.image = image
        titleLabel.text = title
    }
}
