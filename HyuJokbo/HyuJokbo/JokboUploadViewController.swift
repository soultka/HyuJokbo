//
//  JokboUploadViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class JokboUploadViewController: UIViewController {

    @IBOutlet weak var TitleTextView: UITextView!
    @IBOutlet weak var ProfessorTextView: UITextView!
    @IBOutlet weak var ContentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TitleTextView?.becomeFirstResponder()
        self.TitleTextView?.text = " 수업명"
        self.TitleTextView?.textColor = UIColor.lightGray
        self.ProfessorTextView?.text = " 교수님"
        self.ProfessorTextView?.textColor = UIColor.lightGray
        self.ContentTextView?.text = " 여기를 눌러서 글을 작성할 수 있습니다."
        self.ContentTextView?.textColor = UIColor.lightGray
        
        self.TitleTextView?.layer.borderWidth = 1
        self.TitleTextView?.layer.borderColor = UIColor.lightGray.cgColor
        self.ProfessorTextView?.layer.borderWidth = 1
        self.ProfessorTextView?.layer.borderColor = UIColor.lightGray.cgColor
        self.ContentTextView?.layer.borderWidth = 1
        self.ContentTextView?.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.TitleTextView?.setContentOffset(CGPoint.zero, animated: false)
        self.ProfessorTextView?.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
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
