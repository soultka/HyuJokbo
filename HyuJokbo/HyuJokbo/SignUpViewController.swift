//
//  SignUpViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 5. 26..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HyuJokboLogo: UIImageView!
    @IBOutlet weak var SignUpButton: UIButton!
    
    var ref: FIRDatabaseReference?
    
    var placeHolderColor: UIColor = UIColor(red: 193/255, green: 203/255, blue: 234/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        EmailTextField.text = "이메일을 입력해주세요."
        EmailTextField.font = .systemFont(ofSize:10)
        EmailTextField.textColor = UIColor.white
        EmailTextField.delegate = self
        EmailTextField.tag = 0
        let emailBorder = CALayer()
        let ewidth = CGFloat(0.5)
        emailBorder.borderColor = placeHolderColor.cgColor
        emailBorder.frame = CGRect(x: 0, y: EmailTextField.frame.size.height - ewidth, width:  EmailTextField.frame.size.width, height: EmailTextField.frame.size.height)
        emailBorder.borderWidth = ewidth
        EmailTextField.layer.addSublayer(emailBorder)
        EmailTextField.layer.masksToBounds = true
        EmailTextField.delegate = self
        EmailTextField.tag = 0

        PasswordTextField.text = "비밀번호를 입력해주세요."
        PasswordTextField.font = .systemFont(ofSize:10)
        PasswordTextField.textColor = UIColor.white
        PasswordTextField.delegate = self
        PasswordTextField.tag = 1
        PasswordTextField.isSecureTextEntry = false
        let passwordBorder = CALayer()
        let pwidth = CGFloat(0.5)
        passwordBorder.borderColor = placeHolderColor.cgColor
        passwordBorder.frame = CGRect(x: 0, y: PasswordTextField.frame.size.height - pwidth, width: PasswordTextField.frame.size.width, height: PasswordTextField.frame.size.height)
        passwordBorder.borderWidth = pwidth
        PasswordTextField.layer.addSublayer(passwordBorder)
        PasswordTextField.layer.masksToBounds = true
        PasswordTextField.delegate = self
        PasswordTextField.tag = 1
        PasswordTextField.isSecureTextEntry = false
        
        SignUpButton.backgroundColor = UIColor(red: 131/255, green: 154/255, blue: 213/255, alpha: 1.0)
        SignUpButton.layer.cornerRadius = 3
        SignUpButton.layer.borderWidth = 1
        SignUpButton.layer.borderColor = UIColor(red: 131/255, green: 154/255, blue: 213/255, alpha: 1.0).cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == false {
            textField.text = nil
            textField.textColor = UIColor.white
            if textField.tag == 1 {
                PasswordTextField.isSecureTextEntry = true
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            if textField.tag == 0 {
                textField.text = "이메일을 입력해주세요."
            } else if textField.tag == 1 {
                textField.text = "비밀번호를 입력해주세요."
                PasswordTextField.isSecureTextEntry = false
                
            }
            textField.textColor = UIColor.white
        }
    }

    @IBAction func SignUpButtonTapped(_ sender: Any) {
        if EmailTextField.text == "이메일을 입력해주세요." || (EmailTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "알림", message:
                "이메일을 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        } else if PasswordTextField.text == "비밀번호를 입력해주세요." || (PasswordTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "알림", message:
                "비밀번호를 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if let email = EmailTextField.text, let password = PasswordTextField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if let u = user {

                    self.signIn()
                    
                } else {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            let alertController = UIAlertController(title: "알림", message:
                                "이메일 형식이 유효하지 않습니다.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        case .errorCodeEmailAlreadyInUse:
                            let alertController = UIAlertController(title: "알림", message:
                                "이미 사용 중인 이메일입니다.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            return
                        case .errorCodeWeakPassword:
                            let alertController = UIAlertController(title: "알림", message:
                                "비밀번호는 6자 이상이어야 합니다.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            return
                        default:
                            print("에러 메세지 : \(error!)")
                        }
                    }
                }
            })
        }

    }

    func signIn(){
        self.addUser()
        self.loadUser()
        self.performSegue(withIdentifier: "signInSegue", sender: self)
        ref?.removeAllObservers()
    }

    func addUser(){

        if let userID = FIRAuth.auth()?.currentUser{
            g_CurUser.uid = userID.uid
            g_CurUser.email = userID.email!
        }

        print("only in sinn")
        let curRef = self.ref?.child("users").child(g_CurUser.uid)
        curRef?.child("email").setValue(g_CurUser.email)
        //print(curRef?.child("rcvLikeNum"))

    }

    func loadUser(){

        let curRef = ref?.child("users").child(g_CurUser.uid)
        var isLikeFirst = true
        var isCommentFirst = true
        ref?.child("users").child(g_CurUser.uid).observeSingleEvent(of:.value, with: { (snapshot) in


            var snapKey = snapshot.key as String

            if let email = snapshot.childSnapshot(forPath: "email").value as? String{
                g_CurUser.email = email
            }
            if let image = snapshot.childSnapshot(forPath: "image").value as? String{
                g_CurUser.image = image
            }
            if let sndLike = snapshot.childSnapshot(forPath: "sndLikeJokbo").value as? [String:String]{
                g_CurUser.sndLikeJokbo = Array((sndLike.values))
            }
            if let sndUpload = snapshot.childSnapshot(forPath: "sndUploadJokbo").value as? [String:String]{
                g_CurUser.sndUploadJokbo = Array((sndUpload.values))
            }
            if let sndBookmarkload = snapshot.childSnapshot(forPath: "sndBookmarkJokbo").value as? [String:String]{
                g_CurUser.sndBookmarkJokbo = Array((sndBookmarkload.values))
            }
            if let rcvLikeNum = snapshot.childSnapshot(forPath: "rcvLikeNum").value as? String{
                g_CurUser.rcvLikeNum = Int(rcvLikeNum)!
            }else {
                curRef?.child("rcvLikeNum").setValue("0")
            }

            if let rcvCommentNum = snapshot.childSnapshot(forPath: "rcvCommentNum").value as? String{
                g_CurUser.rcvCommentNum = Int(rcvCommentNum)!

            }else{
                curRef?.child("rcvCommentNum").setValue("0")
            }


            
            
        })
        
        
        
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
