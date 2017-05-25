//
//  HonorMemberButton.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 25..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
protocol HonorMemberButtonDelegate  {
    func HonorButtonTouchBegan()
    func HonorButtonGesture()
}

class HonorMemberButton: UIButton, UIGestureRecognizerDelegate {
    var delegate:HonorMemberButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
/*
        let myPanGesture = UIPanGestureRecognizer(target: self, action: #selector(HonorMemberButton.PanGestureRecognizer(_:shouldRecognizeSimultaneouslyWith:)))
        myPanGesture.delegate = self
        self.addGestureRecognizer(myPanGesture)
 */

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button \(self.titleLabel?.text)")
        // 임의로 만든 플로우 스크롤 뷰이기 때문에, 터치하면 스크롤뷰가 제자리를 돌아가려고 움직인다.
        // 따라서
        //스크롤뷰가 못움직이게 강제 락을 건다.
        delegate?.HonorButtonTouchBegan()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("button end")
        
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("hello button")
        //락을 푼다
         delegate?.HonorButtonGesture()
    }

/*
    func PanGestureRecognizer(_ PanGestureRecognizer: UIPanGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        switch PanGestureRecognizer.state {

        case .began:
            delegate?.HonorButtonGesture()
            print("g---hello button")


            print("g---button \(self.titleLabel?.text)")
            delegate?.HonorButtonTouchBegan()

        case .ended, .cancelled, .failed:
            print("g---button end")

        case .changed:
            print("g---hello button")
            delegate?.HonorButtonGesture()

        default:
            break;
        }

//        print("g-g-g-g-g-g-")
        return true
    }

*/
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}