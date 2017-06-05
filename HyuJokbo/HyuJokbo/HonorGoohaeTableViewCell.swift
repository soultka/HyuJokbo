
//
//  HonorGoohaeTableViewCell.swift
//  HyuGoohae
//
//  Created by ByoungWook Park on 2017. 6. 2..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorGoohaeTableViewCell: UITableViewCell {

    @IBOutlet weak var RankNumLabel: UILabel!
    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var ProfessorLabel: UILabel!
    @IBOutlet weak var LikeNumLabel: UILabel!
    @IBOutlet weak var CommentNumLabel: UILabel!
    @IBOutlet weak var BookmarkNumLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
