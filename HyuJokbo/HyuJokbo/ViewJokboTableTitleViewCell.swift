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
    @IBOutlet weak var ChatNumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /*SubjectLabel.text = "소프트웨어 스튜디오"
        ProfessorLabel.text = "유민수 교수님"
        UserInfoNameLabel.text = "신지원"
        UserInfoUploadTime.text = "2017.5.6 07:32"
        */
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
