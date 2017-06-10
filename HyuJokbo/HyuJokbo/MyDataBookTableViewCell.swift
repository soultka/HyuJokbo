//
//  MyDataBookTableViewCell.swift
//  HyuJokbo
//
//  Created by 박한솔 on 2017. 6. 10..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class MyDataBookTableViewCell: UITableViewCell {

    @IBOutlet weak var ProfessorName: UILabel!
    @IBOutlet weak var NumofCell: UILabel!
    @IBOutlet weak var CommentNum: UILabel!
    @IBOutlet weak var SubjectName: UILabel!
    @IBOutlet weak var LikeNum: UILabel!
    @IBOutlet weak var BookmarkNum: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
