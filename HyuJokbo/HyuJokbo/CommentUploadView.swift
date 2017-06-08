//
//  CommentLabel.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class CommentUploadView:UIView, UITextViewDelegate {

    var ref: FIRDatabaseReference?
    
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
        ref = FIRDatabase.database().reference()
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
        self.CommentTextView.textContainerInset = UIEdgeInsetsMake(12, 8, 12, 35)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "댓글을 입력하세요"
            textView.textColor = UIColor.lightGray
        }
    }
   
    func dateString() -> String{
        var dateStr = ""
        let date = Date()
        
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        dateStr += "\(component.year!)"
        if (component.month! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.month!)"
        if (component.day! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.day!)"
        if (component.hour! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.hour!)"
        if (component.minute! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.minute!)"
        if (component.second! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.second!)"
        return dateStr
    }

    @IBAction func addComment(_ sender: Any) {
        if CommentTextView?.text == "댓글을 입력하세요" || (CommentTextView?.text.isEmpty)! {
            return
        }
        
        let rows = Int(round((CommentTextView.contentSize.height - CommentTextView.textContainerInset.top - CommentTextView.textContainerInset.bottom) / CommentTextView.font!.lineHeight))


        if rows > 3 {
            return
        }
        
        var userName: String = ""
        var uploadID: String = ""
        var dateStr: String = ""
        var commentContent: String = ""
            
        if let user = FIRAuth.auth()?.currentUser {
            userName += user.email!
        } else {
            userName += "admin"
        }
            
        uploadID = g_SelectedData
        dateStr += dateString()
        commentContent = CommentTextView.text
            
        let curRef = ref?.child("comments").childByAutoId()
        curRef?.child("userName").setValue(userName)
        curRef?.child("uploadID").setValue(uploadID)
        curRef?.child("updateDate").setValue(dateStr)
        curRef?.child("commentContent").setValue(commentContent)
        
        ref?.child("jokbos").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.hasChild(g_SelectedData) {
                self.ref?.child("jokbos").child(g_SelectedData).updateChildValues(["commentNum": "\((g_JokbosData[g_SelectedData]?.commentNum)!+1)"])
            }
        })
        
        ref?.child("goohaes").observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if snapshot.hasChild(g_SelectedData) {
                self.ref?.child("goohaes").child(g_SelectedData).updateChildValues(["commentNum": "\((g_GoohaesData[g_SelectedData]?.commentNum)!+1)"])
            }
        })

        CommentTextView.text = nil
    }
    
}
