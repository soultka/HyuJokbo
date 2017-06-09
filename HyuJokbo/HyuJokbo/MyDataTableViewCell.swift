//
//  MyDataTableViewCell.swift
//  HyuJokbo
//
//  Created by 박한솔 on 2017. 6. 9..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class MyDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ProfessorLabel: UILabel!
    @IBOutlet weak var BookMarkNumLabel: UILabel!
    @IBOutlet weak var CommentNumLabel: UILabel!
    @IBOutlet weak var LikeNumLabel: UILabel!
    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var NumofTableLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
