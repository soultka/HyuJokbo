//
//  HonorViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorViewController: UIViewController,HorizontalScrollDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let hScroll = HorizontalScroll(frame: CGRect(x: 0, y: 100, width: 400, height: 100))


        hScroll.delegate = self
        hScroll.backgroundColor = UIColor.blue
        self.view.addSubview(hScroll)

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
        var view = UIView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        let button = UIButton()
        button.frame = view.frame
        button.setTitle("hello \(index)", for: UIControlState.normal)
        button.backgroundColor = UIColor.red

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
