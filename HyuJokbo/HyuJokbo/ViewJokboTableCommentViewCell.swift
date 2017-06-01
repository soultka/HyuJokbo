//
//  ViewJokboTableCommentViewCell.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 6. 1..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class ViewJokboTableCommentViewCell: UITableViewCell {
    @IBOutlet weak var UserInfoImage: UIImageView!
    @IBOutlet weak var UserInfoName: UILabel!
    @IBOutlet weak var CommentInfoDate: UILabel!
    @IBOutlet weak var CommentInfoComment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
