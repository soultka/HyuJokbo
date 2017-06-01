//
//  SignUpViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 5. 26..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var HyuJokboLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailTextField.layer.masksToBounds = false
        EmailTextField.layer.shadowRadius = 3.0
        EmailTextField.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        EmailTextField.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        EmailTextField.layer.shadowOpacity = 1.0
        EmailTextField.text = "이메일을 입력해주세요."
        EmailTextField.font = .systemFont(ofSize:10)
        EmailTextField.textColor = UIColor.lightGray
        EmailTextField.delegate = self
        EmailTextField.tag = 0

        PasswordTextField.layer.masksToBounds = false
        PasswordTextField.layer.shadowRadius = 3.0
        PasswordTextField.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        PasswordTextField.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        PasswordTextField.layer.shadowOpacity = 1.0
        PasswordTextField.text = "비밀번호를 입력해주세요."
        PasswordTextField.font = .systemFont(ofSize:10)
        PasswordTextField.textColor = UIColor.lightGray
        PasswordTextField.delegate = self
        PasswordTextField.tag = 1
        PasswordTextField.isSecureTextEntry = false

        HyuJokboLogo.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        HyuJokboLogo.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        HyuJokboLogo.layer.shadowOpacity = 1.0
        HyuJokboLogo.layer.shadowRadius = 3.0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
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
            textField.textColor = UIColor.lightGray
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
                    self.performSegue(withIdentifier: "signUpSegue", sender: self)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
