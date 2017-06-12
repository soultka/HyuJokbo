//
//  ViewJokboTableViewCell.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 6. 1..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class ViewJokboTableTitleViewCell: UITableViewCell {
    
    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var ProfessorLabel: UILabel!
    @IBOutlet weak var UserInfoImage: UIImageView!
    @IBOutlet weak var UserInfoNameLabel: UILabel!
    @IBOutlet weak var UserInfoUploadTime: UILabel!
    @IBOutlet weak var LikeNumLabel: UILabel!
    @IBOutlet weak var CommentNumLabel: UILabel!
    @IBOutlet weak var BookmarkNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        SubjectLabel.adjustsFontSizeToFitWidth = true
        SubjectLabel.minimumScaleFactor = 0.2
        SubjectLabel.numberOfLines = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
