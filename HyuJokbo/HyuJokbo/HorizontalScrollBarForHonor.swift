//
//  HorizontalScrollBar.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

protocol HorizontalScrollDelegate{

    func numberOfScrollViewElements() -> Int

    func elementAtScrollViewIndex(index : Int) -> UIView
}
class HorizontalScroll:UIScrollView {

    var delegateH:HorizontalScrollDelegate?

    let PADDING = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpScroll()
        reload()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setUpScroll()
        reload()

    }

    func setUpScroll(){
        //Make UIScrollView and setting
        self.showsHorizontalScrollIndicator = false
        self.isDirectionalLockEnabled = true

        self.frame = CGRect(x: self.topAnchor.accessibilityActivationPoint.x,
                                y: self.topAnchor.accessibilityActivationPoint.y,
                                width: self.frame.width, height: CGFloat(300))

    }


    func reload(){
        if let del = delegateH{

            //xOffset is x offset for each button
            var xOffset:CGFloat = 0
            for index in 0..<del.numberOfScrollViewElements(){
                let view = del.elementAtScrollViewIndex(index: index)

                view.frame = CGRect(x: xOffset, y: CGFloat(0),
                                    width: CGFloat(100.0), height: CGFloat(100.0))

                xOffset = xOffset + CGFloat(PADDING) + view.frame.size.width

                self.addSubview(view)

            }
            self.frame = CGRect(x: self.topAnchor.accessibilityActivationPoint.x,
                                y: self.topAnchor.accessibilityActivationPoint.y,
                                width: xOffset, height: CGFloat(300))
            self.contentSize = CGSize(width: xOffset, height:1.0)


        }
    }


}
