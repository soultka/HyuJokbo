//
//  HonorMemberImageView.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 6. 2..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorMemberImageView: UIImageView {


    var width:Int = 50
    var height:Int = 50
    var xOffsetOfSuper = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(image: UIImage?) {
        super.init(image: image)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
