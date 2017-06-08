//
//  MyDataJokboTableViewCell.swift
//  HyuJokbo
//
//  Created by 박한솔 on 2017. 6. 8..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class MyDataJokboTableViewCell: UITableViewCell {

    @IBOutlet weak var NumOfTable: UILabel!
    @IBOutlet weak var ProfessorLabel: UILabel!
    @IBOutlet weak var BookMarkNumlabel: UILabel!
    @IBOutlet weak var CommentNumLabel: UILabel!
    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var LikeNumLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
