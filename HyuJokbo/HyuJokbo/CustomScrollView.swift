//
//  CustomScrollView.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
    }

    self.showsHorizontalScrollIndicator = false
    self.isDirectionalLockEnabled = true
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }

}
