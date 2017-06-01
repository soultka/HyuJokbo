//
//  ViewJokboTableContentViewCell.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 6. 1..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class ViewJokboTableContentViewCell: UITableViewCell {

    @IBOutlet weak var JokboImage: UIImageView!
    @IBOutlet weak var ContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
