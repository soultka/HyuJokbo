//
//  GoohaeUploadViewController.swift
//  HyuGoohae
//
//  Created by Jiwon Shin on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GoohaeUploadViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var TitleTextView: UITextView!
    @IBOutlet weak var ProfessorTextView: UITextView!
    @IBOutlet weak var ContentTextView: UITextView!

    var ref: FIRDatabaseReference?

    var TitlePlaceholderLabel: UILabel!
    var ProfessorPlaceholderLabel: UILabel!
    var ContentPlaceholderLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()

        self.TitleTextView.delegate = self
        self.ProfessorTextView.delegate = self
        self.ContentTextView.delegate = self

        self.TitleTextView.tag = 0
        self.ProfessorTextView.tag = 1
        self.ContentTextView.tag = 2

        self.TitleTextView?.text = " 수업명"
        self.TitleTextView?.textColor = UIColor.lightGray
        self.ProfessorTextView?.text = " 교수님"
        self.ProfessorTextView?.textColor = UIColor.lightGray
        self.ContentTextView?.text = " 여기를 눌러서 글을 작성할 수 있습니다."
        self.ContentTextView?.textColor = UIColor.lightGray

        self.TitleTextView?.layer.borderWidth = 0.5
        self.TitleTextView?.layer.borderColor = UIColor.lightGray.cgColor
        self.ProfessorTextView?.layer.borderWidth = 0.5
        self.ProfessorTextView?.layer.borderColor = UIColor.lightGray.cgColor
        self.ContentTextView?.layer.borderWidth = 0.5
        self.ContentTextView?.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.TitleTextView?.setContentOffset(CGPoint.zero, animated: false)
        self.ProfessorTextView?.setContentOffset(CGPoint.zero, animated: false)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView.tag == 0 {
                textView.text = " 수업명"
            } else if textView.tag == 1 {
                textView.text = " 교수님"
            } else if textView.tag == 2 {
                textView.text = " 여기를 눌러서 글을 작성할 수 있습니다."
            }
            textView.textColor = UIColor.lightGray
        }
    }

    @IBAction func addGoohae(_ sender: Any) {
        // TODO: post the goohae to firebase
        let curRef = ref?.child("goohaes").childByAutoId()
        curRef?.child("className").setValue(TitleTextView.text)
        curRef?.child("professorName").setValue(ProfessorTextView.text)
        curRef?.child("goohaeText").setValue(ContentTextView.text)
        // Dismiss the popover
        presentingViewController?.dismiss(animated: true, completion: nil)
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
