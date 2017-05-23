//
//  SearchLabel.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class SearchView:UIView, UITextViewDelegate{

    @IBOutlet weak var SearchTextView: UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    func commonInit(){
        //SearchView.xib 파일을 얻어옴(owner는 File's Owner에서 정해주었음)
        let view = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)

        //for UITextView
        self.SearchTextView.delegate = self
        self.SearchTextView.text = "검색어를 입력하세요"
        self.SearchTextView.textColor = UIColor.lightGray
        self.SearchTextView.layer.borderWidth = 0.5
        self.SearchTextView.layer.borderColor = UIColor.lightGray.cgColor

    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            SearchTextView.text = "검색어를 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }


}
