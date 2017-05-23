//
//  HonorViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorViewController: UIViewController, UIScrollViewDelegate {

    var superViewWidth:CGFloat!
    var superViewHeight:CGFloat!
    var scrollViewY:CGFloat!
    var scrollViewHeight:CGFloat!
    var buttonWidth:CGFloat!
    var buttonHeight:CGFloat!
    let PADDING = CGFloat(10)

    @IBOutlet weak var slideScroll: UIScrollView!
    @IBOutlet weak var PageControl: UIPageControl!
    @IBOutlet weak var CenterMemberLabel: UILabel!



    override func viewDidLoad() {
        super.viewDidLoad()
        superViewWidth = CGFloat(300)
        superViewHeight = self.view.frame.height
        scrollViewY = CGFloat(100)
        scrollViewHeight = CGFloat(150)
        buttonWidth = CGFloat(100)
        buttonHeight = CGFloat(100)


        //For ScrollView---
        slideScroll.delegate = self
        setUpScroll()
        reloadScroll()

        //For PageControl
        PageControl.numberOfPages = self.numberOfScrollViewElements()
        PageControl.currentPage = 0


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfScrollViewElements() -> Int {
        return 10
    }

    func elementAtScrollViewIndex(index: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        let button = UIButton()
        button.frame = view.frame
        button.setImage(UIImage(named:"icon-mydata(b)"), for: UIControlState.normal)

        view.addSubview(button)
        return view
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/(buttonWidth*3))
        PageControl.currentPage = Int(pageIndex)
    }

    func setUpScroll(){
        //Make UIScrollView and setting
        slideScroll.showsHorizontalScrollIndicator = false
        slideScroll.isDirectionalLockEnabled = true
        slideScroll.isPagingEnabled = true

        slideScroll.frame = CGRect(x: 0,
                            y: scrollViewY,
                            width: superViewWidth, height: scrollViewHeight)

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


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
