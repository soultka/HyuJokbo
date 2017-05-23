//
//  HonorViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorViewController: UIViewController,HorizontalScrollDelegate {

    var superViewWidth:CGFloat!
    var superViewHeight:CGFloat!

    @IBOutlet weak var CenterMemberLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        superViewWidth = self.view.frame.width
        superViewHeight = self.view.frame.height

        //For ScrollView---begin
        let hScroll = HorizontalScroll(frame:
            CGRect(x: 0, y: superViewHeight/5, width: superViewWidth, height: superViewHeight/5))

        hScroll.delegate = self
        hScroll.backgroundColor = UIColor.white
        self.view.addSubview(hScroll)
        //For ScrollView---end


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
        var view = UIView(frame: CGRect(x: 0, y: 0, width: superViewWidth/5, height: superViewHeight/5))
        let button = UIButton()
        button.frame = view.frame
        button.setImage(UIImage(named:"icon-mydata(b)"), for: UIControlState.normal)



        view.addSubview(button)
        return view
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
