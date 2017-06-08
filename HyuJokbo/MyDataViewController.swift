//
//  MyDataViewController.swift
//  HyuJokbo
//
//  Created by 박한솔 on 2017. 6. 7..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseAuth


class MyDataViewController: UIViewController {

    @IBOutlet weak var viewComment: UILabel!
    @IBOutlet weak var viewLike: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myName: UILabel!
    let user = User()
    var userLike = 0
    var userComment = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImage.image = #imageLiteral(resourceName: "icon-mydata(g)")
        if let userID = FIRAuth.auth()?.currentUser{
            user.email = userID.email!
        }
        if let index = user.email.range(of: "@")?.lowerBound{
            myName.text = user.email.substring(to: index)
        }else{
            myName.text = user.email
        }
         viewLike.text = String(userLike)
         viewComment.text = String(userComment)
        
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func JokboLike () -> (){
        for i in 1...g_JokbosArray.count {
            let temp_jokbo = g_JokbosArray[i-1]
            if(temp_jokbo.userName == user.email){
                userLike += temp_jokbo.likeNum
            }
        }
    }
    
    func goohaeLike () -> (){
        for i in 1...g_GoohaesArray.count {
            let temp_goohae = g_GoohaesArray[i-1]
            if(temp_goohae.userName == user.email){
                userLike += temp_goohae.likeNum
            }
        }
    }
    func JokboComment () -> (){
        for i in 1...g_JokbosArray.count {
            let temp_jokbo = g_JokbosArray[i-1]
            if(temp_jokbo.userName == user.email){
                userComment += temp_jokbo.commentNum
            }
        }
    }
    
    func goohaeComment () -> (){
        for i in 1...g_GoohaesArray.count {
            let temp_goohae = g_GoohaesArray[i-1]
            if(temp_goohae.userName == user.email){
                userComment += temp_goohae.commentNum
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userLike = 0
        JokboLike()
        goohaeLike()
        JokboComment()
        goohaeComment()
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
