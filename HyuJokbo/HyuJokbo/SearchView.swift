//
//  SearchLabel.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class SearchView:UIView, UITextFieldDelegate{

    @IBOutlet weak var SearchTextField: UITextField!
   
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
        self.SearchTextField.delegate = self
        self.SearchTextField.text = "검색어를 입력하세요"
        self.SearchTextField.textColor = UIColor.lightGray
        self.SearchTextField.layer.borderWidth = 0.5
        self.SearchTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.SearchTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5.0, 0.0, 0.0)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextView) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }

    func textFieldDidEndEditing(_ textField: UITextView) {
        if textField.text.isEmpty {
            SearchTextField.text = "검색어를 입력하세요"
            textField.textColor = UIColor.lightGray
        }
    }
    @IBAction func cancelEditing(_ sender: Any) {

        if self.SearchTextField.text != "검색어를 입력하세요"{
            self.SearchTextField.text = nil
            self.SearchTextField.endEditing(true)
        }


    }

}
