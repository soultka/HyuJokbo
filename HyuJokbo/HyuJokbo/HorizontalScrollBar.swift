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
class HorizontalScroll:UIView {

    var delegate:HorizontalScrollDelegate?

    var scroller:UIScrollView!
    let PADDING = 10

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpScroll()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        setUpScroll()

    }

    func setUpScroll(){
        scroller = UIScrollView()
        scroller.frame = CGRect(x: self.topAnchor.accessibilityActivationPoint.x,
                                y: self.topAnchor.accessibilityActivationPoint.y,
                                width: 400, height: CGFloat(300))

        scroller.showsHorizontalScrollIndicator = false
        
        scroller.isDirectionalLockEnabled = true


        self.addSubview(scroller)


        scroller.translatesAutoresizingMaskIntoConstraints = false
        let dict = ["scroller": scroller]

        //슈퍼부의 리딩과 트레일링과 스크롤러의 간격을0으로 맞춤
        let constraint1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|[scroller]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)

        //슈퍼부의 버티컬 리딩과 트레일링과 스크롤러의 간격을 0으로 맟춤
        let constraint2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|[scroller]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict)

        self.addConstraints(constraint1)
        self.addConstraints(constraint2)
        self.addSubview(scroller)


    }

    override func didMoveToSuperview() {
        reload()
    }

    func reload(){
        if let del = delegate{

            var xOffset:CGFloat = 0
            for index in 0..<del.numberOfScrollViewElements(){
                let view = del.elementAtScrollViewIndex(index: index)

                view.frame = CGRect(x: xOffset, y: CGFloat(0), width: CGFloat(100.0), height: CGFloat(50.0))
                xOffset = xOffset + CGFloat(PADDING) + view.frame.size.width
                scroller.addSubview(view)

            }
            scroller.contentSize = CGSize(width: xOffset, height:1.0)
            scroller.frame = CGRect(x: scroller.topAnchor.accessibilityActivationPoint.x,
                                    y: scroller.topAnchor.accessibilityActivationPoint.y,
                                    width: xOffset, height: CGFloat(300))

            print("\(self.frame.width),\(self.frame.height)")
            print("\(scroller.frame.width),\(scroller.frame.height)")
            print("\(scroller.contentSize.width),\(scroller.contentSize.height)")

        }
    }


}
