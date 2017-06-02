//
//  HonorViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorViewController: UIViewController, UIScrollViewDelegate, HonorMemberButtonDelegate{

    var superViewWidth:CGFloat!
    var superViewHeight:CGFloat!
    var scrollViewY:CGFloat!
    var scrollViewWidth:CGFloat!
    var scrollViewHeight:CGFloat!
    var buttonWidth:CGFloat!
    var buttonHeight:CGFloat!
    var memberImageWidth:CGFloat!
    let PADDING = CGFloat(10)

    var imageViews:[HonorMemberImageView] = []
    @IBOutlet weak var slideScroll: HorizontalScrollView!
    @IBOutlet weak var CenterMemberLabel: UILabel!

    @IBOutlet weak var InvisibleScroll: UIScrollView!


    override func viewDidLoad() {
        super.viewDidLoad()
        superViewWidth = self.view.frame.height
        superViewHeight = self.view.frame.height
        scrollViewY = CGFloat(100)
        scrollViewWidth = CGFloat(300)
        scrollViewHeight = CGFloat(100)
        buttonWidth = CGFloat(100)
        buttonHeight = CGFloat(100)
        memberImageWidth = CGFloat(80)

        self.CenterMemberLabel.text = "Member : 1"


        //For ScrollView---

        setUpScroll()
        reloadScroll()
        scrollViewDidScroll(InvisibleScroll)


        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfScrollViewElements() -> Int {
        return 10
    }


    func elementAtScrollViewIndex(index: Int) -> UIButton {

        let button = HonorMemberButton()
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
//        button.setTitle("\(index)!!", for: UIControlState.normal)
//        button.setTitleColor(UIColor.black, for: UIControlState.normal)
//        button.backgroundColor = UIColor.blue

//                        button.setImage(UIImage(named:"icon-h_mydata(b)"), for: UIControlState.normal)

        if(button.imageAddedFlag == 0){
            let imageView = HonorMemberImageView(image: UIImage(named: "icon-h_mydata(b)"))
            imageViews.insert(imageView,at:index)

            let slideInt = Int(slideScroll.contentOffset.x)
            let scrollViewWidth  = Int(self.scrollViewWidth)
            let intxoffset = imageViews[index].xOffsetOfSuper
            let ButtonWidth = Int(self.buttonWidth)

            let differency = (slideInt + scrollViewWidth/2) - (intxoffset + ButtonWidth/2)
            imageViews[index].width = Int(memberImageWidth) - (abs(differency))/4
            imageViews[index].height = imageViews[index].width

            imageViews[index].frame = CGRect(x: (Int(buttonWidth) - imageViews[index].width)/2,
                                             y: (Int(buttonHeight) - imageViews[index].height)/2,
                                             width: imageViews[index].width,
                                             height: imageViews[index].height)
            button.addSubview(imageViews[index])
            button.imageAddedFlag = 1
        }
        button.delegate = self




        return button
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {

//        if(scrollView == InvisibleScroll){
            slideScroll.contentOffset = InvisibleScroll.contentOffset

            let index = Int((Double(slideScroll.contentOffset.x)/Double(buttonWidth)).rounded()) + 1
            print("moved \(Int(slideScroll.contentOffset.x)/Int(buttonWidth))")
            self.CenterMemberLabel.text = "Member\(index)"
//        }

        for index in stride(from: 0, to: self.numberOfScrollViewElements(), by: 1)
        {
        let slideInt = Int(slideScroll.contentOffset.x)
        let scrollViewWidth  = Int(self.scrollViewWidth)
        let intxoffset = imageViews[index].xOffsetOfSuper
        let ButtonWidth = Int(self.buttonWidth)

        let differency = (slideInt + scrollViewWidth/2) - (intxoffset + ButtonWidth/2)
        imageViews[index].width = Int(memberImageWidth) - (abs(differency))/4
        imageViews[index].height = imageViews[index].width
        imageViews[index].frame = CGRect(x: (Int(buttonWidth) - imageViews[index].width)/2,
                                         y: (Int(buttonHeight) - imageViews[index].height)/2,
                                         width: imageViews[index].width,
                                         height: imageViews[index].height)
        }

    }


    func setUpScroll(){
        //Make UIScrollView and setting
        slideScroll.showsHorizontalScrollIndicator = false
        slideScroll.isDirectionalLockEnabled = true
//        slideScroll.isPagingEnabled = true

        slideScroll.isMultipleTouchEnabled = false


        slideScroll.translatesAutoresizingMaskIntoConstraints = false
        slideScroll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        slideScroll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        slideScroll.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true
        slideScroll.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true

        InvisibleScroll.showsHorizontalScrollIndicator = false
        InvisibleScroll.isDirectionalLockEnabled = true
        InvisibleScroll.isPagingEnabled = true


        InvisibleScroll.translatesAutoresizingMaskIntoConstraints = false
        InvisibleScroll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        InvisibleScroll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        InvisibleScroll.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        InvisibleScroll.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true


        InvisibleScroll.isUserInteractionEnabled = false

        slideScroll.addGestureRecognizer(InvisibleScroll.panGestureRecognizer)


        InvisibleScroll.delegate = self
        self.view.bringSubview(toFront: slideScroll)

    }


    func reloadScroll(){

        //xOffset is x offset for each button
        var xOffset:CGFloat = 0
        for index in 0..<self.numberOfScrollViewElements(){
            let view = self.elementAtScrollViewIndex(index: index)

            view.frame = CGRect(x: xOffset, y: CGFloat(0),
                                width: buttonWidth, height: buttonHeight)

            imageViews[index].xOffsetOfSuper = Int(xOffset)
            xOffset = xOffset + buttonWidth

            slideScroll.addSubview(view)

        }
        slideScroll.contentSize = CGSize(width: xOffset + buttonWidth, height:scrollViewHeight)
        InvisibleScroll.contentSize = CGSize(width: xOffset - buttonWidth, height:scrollViewHeight)


    }


    func HonorButtonTouchBegan() {
        slideScroll.isScrollEnabled = false
        slideScroll.isPagingEnabled = false
        scrollViewDidScroll(InvisibleScroll)
        
    }
    func HonorButtonGesture() {
        print(Int(InvisibleScroll.contentOffset.x)/Int(buttonWidth))
        slideScroll.isScrollEnabled = true
        slideScroll.isPagingEnabled = true
        
    }
    
}
