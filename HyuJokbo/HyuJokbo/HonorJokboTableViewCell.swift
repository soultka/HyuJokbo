
//
//  HonorJokboTableViewCell.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 6. 2..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorJokboTableViewCell: UITableViewCell {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var LikeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.TitleLabel.text = "안녕"
        self.LikeLabel.text = "10"
        self.commentLabel.text = "9"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
