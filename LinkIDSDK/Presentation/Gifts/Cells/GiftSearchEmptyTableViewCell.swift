//
//  GiftSearchEmptyTableViewCell.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 29/05/2024.
//

import UIKit

class GiftSearchEmptyTableViewCell: UITableViewCell {
    
    var onSearchAnotherText: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func searchAnotherTextAction(_ sender: Any) {
        onSearchAnotherText?()
    }
    
}