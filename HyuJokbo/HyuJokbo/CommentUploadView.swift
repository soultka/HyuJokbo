//
//  CommentLabel.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class CommentUploadView:UIView, UITextViewDelegate{

    @IBOutlet weak var CommentTextView: UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    func commonInit(){
        //CommentView.xib 파일을 얻어옴(owner는 File's Owner에서 정해주었음)
        let view = Bundle.main.loadNibNamed("CommentUploadView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)

        //for UITextView
        self.CommentTextView.delegate = self
        self.CommentTextView.text = "댓글을 입력하세요"
        self.CommentTextView.textColor = UIColor.lightGray
        self.CommentTextView.layer.borderWidth = 0.5
        self.CommentTextView.layer.borderColor = UIColor.lightGray.cgColor

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            CommentTextView.text = "댓글을 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
    @IBAction func cancelEditing(_ sender: Any) {

        if self.CommentTextView.text != "댓글을 입력하세요"{
            self.CommentTextView.text = nil
            self.CommentTextView.endEditing(true)
        }
        
        
    }
    @IBAction func SendText(_ sender: Any) {
        print(self.CommentTextView.text)
    }
    
}