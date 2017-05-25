//
//  LoginViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 5. 21..
//  Copyright © 2017년 박한솔. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var HyuJokboContinueButton: UIButton!
    @IBOutlet weak var FacebookContinueButton: UIButton!
    @IBOutlet weak var GoogleContinueButton: UIButton!
    @IBOutlet weak var HyuJokboLogo: UIImageView!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var attrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 7.0),
        NSForegroundColorAttributeName : UIColor.white,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    
    var attributedString = NSMutableAttributedString(string:"아직 회원이 아니신가요? 회원가입")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        EmailTextField.layer.masksToBounds = false
        EmailTextField.layer.shadowRadius = 3.0
        EmailTextField.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        EmailTextField.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        EmailTextField.layer.shadowOpacity = 1.0
        EmailTextField.text = "이메일"
        EmailTextField.font = .systemFont(ofSize:10)
        EmailTextField.textColor = UIColor.lightGray
        EmailTextField.delegate = self
        EmailTextField.tag = 0
        
        PasswordTextField.layer.masksToBounds = false
        PasswordTextField.layer.shadowRadius = 3.0
        PasswordTextField.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        PasswordTextField.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        PasswordTextField.text = "비밀번호"
        PasswordTextField.font = .systemFont(ofSize:10)
        PasswordTextField.textColor = UIColor.lightGray
        PasswordTextField.layer.shadowOpacity = 1.0
        PasswordTextField.delegate = self
        PasswordTextField.tag = 1
        
        HyuJokboContinueButton.backgroundColor = UIColor(red: 252/255, green: 103/255, blue: 0/255, alpha: 1.0)
        HyuJokboContinueButton.layer.cornerRadius = 5
        HyuJokboContinueButton.layer.borderWidth = 1
        HyuJokboContinueButton.layer.borderColor = UIColor(red: 252/255, green: 103/255, blue: 0/255, alpha: 1.0).cgColor
        HyuJokboContinueButton.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        HyuJokboContinueButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        HyuJokboContinueButton.layer.shadowOpacity = 1.0
        HyuJokboContinueButton.layer.shadowRadius = 3.0
        
        let buttonTitleStr = NSMutableAttributedString(string:"아직 회원이 아니신가요? 회원가입", attributes:attrs)
        attributedString.append(buttonTitleStr)
        
        
        FacebookContinueButton.backgroundColor = UIColor(red: 56/255, green: 84/255, blue: 148/255, alpha: 1.0)
        FacebookContinueButton.layer.cornerRadius = 5
        FacebookContinueButton.layer.borderWidth = 1
        FacebookContinueButton.layer.borderColor = UIColor(red: 56/255, green: 84/255, blue: 148/255, alpha: 1.0).cgColor
        FacebookContinueButton.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        FacebookContinueButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        FacebookContinueButton.layer.shadowOpacity = 1.0
        FacebookContinueButton.layer.shadowRadius = 3.0
        
        GoogleContinueButton.backgroundColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1.0)
        GoogleContinueButton.layer.cornerRadius = 5
        GoogleContinueButton.layer.borderWidth = 1
        GoogleContinueButton.layer.borderColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1.0).cgColor
        GoogleContinueButton.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        GoogleContinueButton.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        GoogleContinueButton.layer.shadowOpacity = 1.0
        GoogleContinueButton.layer.shadowRadius = 3.0
        
        
        HyuJokboLogo.layer.shadowColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        HyuJokboLogo.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        HyuJokboLogo.layer.shadowOpacity = 1.0
        HyuJokboLogo.layer.shadowRadius = 3.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            if textField.tag == 0 {
                textField.text = "이메일"
            } else if textField.tag == 1 {
                textField.text = "비밀번호"
            }
            textField.textColor = UIColor.lightGray
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
