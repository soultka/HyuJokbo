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
    var scrollViewHeight:CGFloat!
    var buttonWidth:CGFloat!
    var buttonHeight:CGFloat!
    let PADDING = CGFloat(10)

    @IBOutlet weak var slideScroll: HorizontalScrollView!
    @IBOutlet weak var CenterMemberLabel: UILabel!

    @IBOutlet weak var InvisibleScroll: UIScrollView!


    override func viewDidLoad() {
        super.viewDidLoad()
        superViewWidth = CGFloat(300)
        superViewHeight = self.view.frame.height
        scrollViewY = CGFloat(100)
        scrollViewHeight = CGFloat(120)
        buttonWidth = CGFloat(100)
        buttonHeight = CGFloat(100)


        //For ScrollView---

        setUpScroll()
        reloadScroll()


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
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth-10, height: buttonHeight)
        button.setTitle("\(index)!!", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.backgroundColor = UIColor.blue
        //        button.setImage(UIImage(named:"icon-mydata(b)"), for: UIControlState.normal)
        button.delegate = self


        return button
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if(scrollView == InvisibleScroll){
        slideScroll.contentOffset = InvisibleScroll.contentOffset;
        }
        
    }



    func setUpScroll(){
        //Make UIScrollView and setting
//        slideScroll.delegate = self
        slideScroll.showsHorizontalScrollIndicator = true
        slideScroll.isDirectionalLockEnabled = true
        slideScroll.isPagingEnabled = true

//        slideScroll.isUserInteractionEnabled = false
        slideScroll.isMultipleTouchEnabled = false
        slideScroll.canCancelContentTouches = false
        slideScroll.isExclusiveTouch = true
        slideScroll.delaysContentTouches = true
        slideScroll.backgroundColor = UIColor.red


        slideScroll.frame = CGRect(x: 0,
                            y: scrollViewY,
                            width: superViewWidth, height: scrollViewHeight)

        InvisibleScroll.showsHorizontalScrollIndicator = false
        InvisibleScroll.isDirectionalLockEnabled = true
        InvisibleScroll.isPagingEnabled = true
        InvisibleScroll.frame = CGRect(x: buttonWidth,
                                   y: scrollViewY,
                                   width: buttonWidth, height: scrollViewHeight)

        InvisibleScroll.isUserInteractionEnabled = false

        slideScroll.addGestureRecognizer(InvisibleScroll.panGestureRecognizer)


        InvisibleScroll.delegate = self
        self.view.bringSubview(toFront: slideScroll)
        //                InvisibleScroll.delegatePass = self

    }


    func reloadScroll(){

            //xOffset is x offset for each button
            var xOffset:CGFloat = 0
            for index in 0..<self.numberOfScrollViewElements(){
                let view = self.elementAtScrollViewIndex(index: index)

                view.frame = CGRect(x: xOffset, y: CGFloat(0),
                                    width: buttonWidth, height: buttonHeight)

                xOffset = xOffset + buttonWidth

                slideScroll.addSubview(view)

            }
            slideScroll.frame = CGRect(x:0,
                                y: scrollViewY,
                                width: superViewWidth, height: scrollViewHeight)
            slideScroll.contentSize = CGSize(width: xOffset + buttonWidth, height:scrollViewHeight)
        InvisibleScroll.contentSize = CGSize(width: xOffset - buttonWidth, height:scrollViewHeight)


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func HonorButtonTouchBegan() {
        slideScroll.isScrollEnabled = false
        slideScroll.isPagingEnabled = false

    }
    func HonorButtonGesture() {
        print("kk")
        slideScroll.isScrollEnabled = true
        slideScroll.isPagingEnabled = true

    }

}
