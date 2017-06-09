//
//  MyDataViewController.swift
//  HyuJokbo
//
//  Created by 박한솔 on 2017. 6. 7..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseAuth


class MyDataViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var BookMarkedTableView: UITableView!
    @IBOutlet weak var viewComment: UILabel!
    @IBOutlet weak var viewLike: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myName: UILabel!
    let user = User()
    var userLike = 0
    var userComment = 0
    var BookedJokbo : [Jokbo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print(BookedJokbo)
        myImage.image = #imageLiteral(resourceName: "icon-mydata")
        myImage.backgroundColor = UIColor.clear
        if let userID = FIRAuth.auth()?.currentUser{
            user.email = userID.email!
        }
        if let index = user.email.range(of: "@")?.lowerBound{
            myName.text = user.email.substring(to: index)
        }else{
            myName.text = user.email
        }
        BookMarkedTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        BookMarkedTableView.delegate = self
        BookMarkedTableView.dataSource = self;
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func JokboLike () -> (){
         userLike = 0
        if g_JokbosArray.count > 0 {
            for i in 1...g_JokbosArray.count {
                let temp_jokbo = g_JokbosArray[i-1]
                if(temp_jokbo.userName == user.email){
                    userLike += temp_jokbo.likeNum
                }
            }
        }
    }
    
    func goohaeLike () -> (){
        if g_GoohaesArray.count > 0 {
            for i in 1...g_GoohaesArray.count {
                let temp_goohae = g_GoohaesArray[i-1]
                if(temp_goohae.userName == user.email){
                    userLike += temp_goohae.likeNum
                }
            }
        }
    }
    func JokboComment () -> (){
        userComment = 0;
        if g_JokbosArray.count > 0 {
            for i in 1...g_JokbosArray.count {
                let temp_jokbo = g_JokbosArray[i-1]
                if(temp_jokbo.userName == user.email){
                    userComment += temp_jokbo.commentNum
                }
            }
        }
    }
    
    func goohaeComment () -> (){
        if g_GoohaesArray.count > 0 {
            for i in 1...g_GoohaesArray.count {
                let temp_goohae = g_GoohaesArray[i-1]
                if(temp_goohae.userName == user.email){
                    userComment += temp_goohae.commentNum
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        JokboLike()
        goohaeLike()
        JokboComment()
        goohaeComment()
        print(userComment)
        print(userLike)
        BookedJokboLoad()
        self.BookMarkedTableView.reloadData()
        viewLike.text = String(userLike)
        viewComment.text = String(userComment)
        //viewComment.text = String(userComment)
    }
    
    func BookedJokboLoad(){
        self.BookedJokbo = g_JokbosArray.filter{$0.userName == self.user.email}
        print("doingwell")
       
         print(self.BookedJokbo)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(BookedJokbo.count)
        return BookedJokbo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell()
        if tableView != self.BookMarkedTableView {
            return myCell
        }
        print("im herer")
        if let myBCell = tableView.dequeueReusableCell(withIdentifier: "MyDataJokboCell", for: indexPath) as? MyDataTableViewCell{
            let jokbo = self.BookedJokbo[indexPath.row]
            print("before return cell")
            myBCell.NumofTableLabel?.text = String(indexPath.row+1)
            myBCell.SubjectLabel?.text  = String(jokbo.className)
            myBCell.ProfessorLabel?.text = String(jokbo.professorName)
            myBCell.LikeNumLabel?.text = String(jokbo.likeNum)
            myBCell.BookMarkNumLabel?.text = String(jokbo.bookmarkNum)
            return myBCell
        }
        return myCell
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
