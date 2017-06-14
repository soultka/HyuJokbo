//
//  LoginViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 5. 21..
//  Copyright © 2017년 박한솔. All rights reserved.
//
import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var HyuJokboContinueButton: UIButton!
    @IBOutlet weak var FacebookContinueButton: UIButton!
    @IBOutlet weak var GoogleContinueButton: UIButton!
    @IBOutlet weak var HyuJokboLogo: UIImageView!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var SignInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!

    var ref: FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    
    
    
    var attrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 7.0),
        NSForegroundColorAttributeName : UIColor.white,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    
    var attributedString = NSMutableAttributedString(string:"아직 회원이 아니신가요? 회원가입")
    var placeHolderColor: UIColor = UIColor(red: 193/255, green: 203/255, blue: 234/255, alpha: 1.0)

    @IBAction func handleModalClose(segue: UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //For DB
        ref = FIRDatabase.database().reference()





        // Do any additional setup after loading the view.
        //EmailTextField Button
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
        
        //PasswordTextField Button
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

        
        //HyuJokboContinue Button
        HyuJokboContinueButton.backgroundColor = UIColor(red: 131/255, green: 154/255, blue: 213/255, alpha: 1.0)
        HyuJokboContinueButton.layer.cornerRadius = 3
        HyuJokboContinueButton.layer.borderWidth = 1
        HyuJokboContinueButton.layer.borderColor = UIColor(red: 131/255, green: 154/255, blue: 213/255, alpha: 1.0).cgColor
        //신규 회원 가입 버튼
        let buttonTitleStr = NSMutableAttributedString(string:"아직 회원이 아니신가요? 회원가입", attributes:attrs)
        attributedString.append(buttonTitleStr)
        
        
        //FacebookContinue Button
        FacebookContinueButton.backgroundColor = UIColor(red: 56/255, green: 84/255, blue: 148/255, alpha: 1.0)
        FacebookContinueButton.layer.cornerRadius = 3
        FacebookContinueButton.layer.borderWidth = 1
        FacebookContinueButton.layer.borderColor = UIColor(red: 56/255, green: 84/255, blue: 148/255, alpha: 1.0).cgColor
                //GoogleContinue Button
        GoogleContinueButton.backgroundColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1.0)
        GoogleContinueButton.layer.cornerRadius = 3
        GoogleContinueButton.layer.borderWidth = 1
        GoogleContinueButton.layer.borderColor = UIColor(red: 223/255, green: 74/255, blue: 50/255, alpha: 1.0).cgColor
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
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
    @IBAction func adminLoginButtonTapped(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: "admin@admin.com", password: "123456", completion: { (user, error) in
            if let u = user  {
                self.signIn()
            }
        })
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
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
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if let u = user  {
                    self.signIn()
                } else {
                    if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                        
                        switch errCode {
                        case .errorCodeInvalidEmail:
                            let alertController = UIAlertController(title: "알림", message:
                                "이메일 형식이 유효하지 않습니다.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        case .errorCodeUserNotFound:
                            let alertController = UIAlertController(title: "알림", message:
                                "해당 이메일로 가입된 계정이 존재하지 않습니다.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            return
                        case .errorCodeWrongPassword:
                            let alertController = UIAlertController(title: "알림", message:
                                "비밀번호가 틀렸습니다.", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            return
                        default:
                            let alertController = UIAlertController(title: "알림", message:
                                "에러 메세지 : \(error!)", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                            return
                        }
                    }
                }
            })
        }
        
    }
    
    @IBAction func FacebookLoginButtonTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("Process error")
            } else {
                let accessToken = FBSDKAccessToken.current()
                guard let accessTokenString = accessToken?.tokenString else
                { return }
                
                let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
                
                FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
                    if let u = user  {
                        self.signIn()
                    } else {
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                            
                            switch errCode {
                            case .errorCodeEmailAlreadyInUse:
                                print("이미 사용 중인 이메일")
                                let alertController = UIAlertController(title: "알림", message:
                                    "이미 사용 중인 이메일입니다.", preferredStyle: UIAlertControllerStyle.alert)
                                alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                                self.present(alertController, animated: true, completion: nil)
                                return
                            default:
                                print("에러 메세지 : \(error!)")
                            }
                        }
                    }
                
                })
                /*FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, err) in
                    
                    if err != nil {
                        print("Failed to start graph request:", err)
                        return
                    } else {
                        
                    }
                })*/
                //self.performSegue(withIdentifier: "signInSegue", sender: self)
            }
        }
    }
    
    @IBAction func GoogleLoginButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
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
        let curRef = self.ref?.child("users").child(g_CurUser.uid)
        curRef?.child("email").setValue(g_CurUser.email)

    }

    func loadUser(){

        for i in stride(from: 0, to: 10, by: 1)
        {
//            ref?.child(<#T##pathString: String##String#>).observeSingleEvent(of: FIRDataEventType, with: <#T##(FIRDataSnapshot) -> Void#>)

            databaseHandle = ref?.child("users").child(g_CurUser.uid).observe(.childAdded, with:{ (snapshot) in
                var snapKey = snapshot.key as String

                if snapKey == "email"{
                    g_CurUser.email = snapshot.value as! String
                }
                if snapKey == "sndLikeJokbo"{
                    g_CurUser.sndLikeJokbo = Array((snapshot.value as! [String:String]).values)

                }
                if snapKey == "sndUploadJokbo"{
                    g_CurUser.sndUploadJokbo = Array((snapshot.value as! [String:String]).values)

                }
                if snapKey == "sndBookmarkJokbo"{
                    g_CurUser.sndBookmarkJokbo = Array((snapshot.value as! [String:String]).values)
                }
                if snapKey == "rcvLikeNum"{
                    //                g_CurUser.rcvLikeNum = snapshot.value as! Int

                }
                if snapKey == "rcvCommentNum"{
                    //                 g_CurUser.rcvCommentNum = snapshot.value as! Int

                }
                if snapKey == "image"{
                    g_CurUser.image = snapshot.value as! String
                    
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
