//
//  ViewGoohaeTableViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 6. 2..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewGoohaeTableViewController: UITableViewController {

    var ref: FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    
    var isLikeButtonTapped: Bool = false
    var isBookMarkButtonTapped: Bool = false
    var isSirenButtonTapped: Bool = false
    var goohae = Goohae()
    var commentsData: [String:Comment] = [:]
    var commentsArray: [Comment] = []
    
    var commentSubView:CommentUploadView!
    var commentSubViewHeight:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        databaseHandle = ref?.child("comments").observe(.childAdded, with: { (snapshot) in
            //Take the value from the snapshot and added it to the jokbosData array
            let data = snapshot.value as? [String:String]
            
            if let commentData = data {
                //Append the data to our jokbo array
                var comment = Comment()
                if g_SelectedData == commentData["uploadID"] {
                    if let userName = commentData["userName"],
                        let uploadID = commentData["uploadID"],
                        let updateDate = commentData["updateDate"],
                        let commentContent = commentData["commentContent"] {
                        comment = Comment(userName: userName, updateDate: updateDate, commentContent: commentContent, uploadID: uploadID)
                        self.commentsData[snapshot.key] = comment
                        self.commentsArray = Array(self.commentsData.values)
                        self.commentsArray.sort {
                            $0.updateDate < $1.updateDate
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
        databaseHandle = ref?.child("comments").observe(.childChanged, with: { (snapshot) in
            //Take the value from the snapshot and added it to the jokbosData array
            let data = snapshot.value as? [String:String]
            
            if let commentData = data {
                //Append the data to our jokbo array
                var comment = Comment()
                if g_SelectedData == commentData["uploadID"] {
                    if let userName = commentData["userName"],
                        let uploadID = commentData["uploadID"],
                        let updateDate = commentData["updateDate"],
                        let commentContent = commentData["commentContent"] {
                        comment = Comment(userName: userName, updateDate: updateDate, commentContent: commentContent, uploadID: uploadID)
                        self.commentsData[snapshot.key] = comment
                        self.commentsArray = Array(self.commentsData.values)
                        self.commentsArray.sort {
                            $0.updateDate < $1.updateDate
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        })

        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        

        //- -   -   -   -   -   -   -   -   -   -   -   COMMENT VIEW ADD
        let subviewPoint = CGPoint(x:self.tableView.contentOffset.x,
                                   y:self.tableView.contentOffset.y + self.tableView.frame.height - self.commentSubViewHeight)
        let subviewCGSize = CGSize(width: self.view.frame.width,
                                   height: self.commentSubViewHeight)
        commentSubView = CommentUploadView(frame:CGRect(origin: subviewPoint, size: subviewCGSize))


        self.view.addSubview(commentSubView)
        self.view.bringSubview(toFront: commentSubView)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()    override func didReceiveMemoryWarning() {
        //super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        scrollViewDidScroll((self.tableView as? UIScrollView)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 || section == 1 {
            return 1
        } else {
            return commentsArray.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewGoohaeTitleCell", for: indexPath) as! ViewJokboTableTitleViewCell
            
            let Date = goohae.updateDate
            
            // Configure the cell...
            
            if let index = goohae.userName.range(of: "@")?.lowerBound{
                cell.UserInfoNameLabel?.text = goohae.userName.substring(to: index)
            } else{
                cell.UserInfoNameLabel?.text = goohae.userName
            }
            
            cell.SubjectLabel?.text = goohae.className
            cell.ProfessorLabel?.text = goohae.professorName
            cell.UserInfoUploadTime?.text = viewDate(date: Date)
            cell.CommentNumLabel?.text = String(commentsArray.count)
            if isLikeButtonTapped == false {
                cell.LikeNumLabel?.text = String(goohae.likeNum)
            } else {
                cell.LikeNumLabel?.text = String(goohae.likeNum+1)
            }
            
            if isBookMarkButtonTapped == false {
                cell.BookmarkNumLabel?.text = String(goohae.bookmarkNum)
            } else {
                cell.BookmarkNumLabel?.text = String(goohae.bookmarkNum+1)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewGoohaeContentCell", for: indexPath) as! ViewJokboTableContentViewCell
            
            cell.ContentLabel?.text = goohae.goohaeText
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewGoohaeCommentCell", for: indexPath) as! ViewJokboTableCommentViewCell
            
            if let index = commentsArray[indexPath.row].userName.range(of: "@")?.lowerBound {
                cell.UserInfoName?.text = commentsArray[indexPath.row].userName.substring(to: index)
            } else {
                cell.UserInfoName?.text = commentsArray[indexPath.row].userName
            }
            
            cell.CommentInfoDate?.text = viewDate(date: Int(commentsArray[indexPath.row].updateDate)!)
            cell.CommentInfoComment?.text = commentsArray[indexPath.row].commentContent

            return cell
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        if isLikeButtonTapped == true {
            let alertController = UIAlertController(title: "알림", message:
                "이미 추천한 게시물입니다.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            ref?.child("goohaes").child(goohae.key).updateChildValues(["likeNum": "\(goohae.likeNum+1)"])
            isLikeButtonTapped = true
            ref?.child("users").child(goohae.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let rcvLikeNum = snapshot.childSnapshot(forPath: "rcvLikeNum").value as? String{
                    self.ref?.child("users").child(self.goohae.uid).updateChildValues(["rcvLikeNum" : "\(Int(rcvLikeNum)! + 1)"])
                    
                    print("check")
                }
            })
            let likeButton = sender as? UIButton
            let goohaeTableView = likeButton?.superview?.superview?.superview?.superview as! UITableView
            let indexPath = IndexPath(row: 0, section: 0)
            let titleCell = goohaeTableView.cellForRow(at: indexPath) as? ViewJokboTableTitleViewCell
            titleCell?.LikeNumLabel?.text = String(goohae.likeNum+1)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        if isBookMarkButtonTapped == true {
            let alertController = UIAlertController(title: "알림", message:
                "이미 스크랩한 게시물입니다.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            ref?.child("goohaes").child(goohae.key).updateChildValues(["bookmarkNum": "\(goohae.bookmarkNum+1)"])
            isBookMarkButtonTapped = true
            
            let bookmarkButton = sender as? UIButton
            let goohaeTableView = bookmarkButton?.superview?.superview?.superview?.superview as! UITableView
            let indexPath = IndexPath(row: 0, section: 0)
            let titleCell = goohaeTableView.cellForRow(at: indexPath) as? ViewJokboTableTitleViewCell
            titleCell?.BookmarkNumLabel?.text = String(goohae.bookmarkNum+1)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func sirenButtonTapped(_ sender: Any) {
        if isSirenButtonTapped == true {
            let alertController = UIAlertController(title: "알림", message:
                "이미 신고한 게시물입니다.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            isSirenButtonTapped = true
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let subviewPoint = CGPoint(x:scrollView.contentOffset.x,
                                   y:scrollView.contentOffset.y + self.tableView.frame.height - self.commentSubViewHeight)
        let subviewCGSize = CGSize(width: self.view.frame.width,
                                   height: self.commentSubViewHeight)
        commentSubView.frame = CGRect(origin: subviewPoint, size: subviewCGSize)

    }
    func viewDate(date DateNum:Int ) -> String{
        var dateString = ""
        var dateN = DateNum
        var year = dateN/10000000000
        dateString += "\(year)."
        dateN = dateN % 10000000000
        var month = dateN/100000000
        if (month / 10 == 0){
            dateString += "0"
        }
        dateString += "\(month)."
        dateN = dateN % 100000000
        var day = dateN / 1000000
        if (month / 10 == 0){
            dateString += "0"
        }
        dateString += "\(day) "
        dateN = dateN % 1000000
        var hour = dateN / 10000
        if (hour / 10 == 0){
            dateString += "0"
        }
        dateString += "\(hour):"
        dateN = dateN % 10000
        var minute = dateN / 100
        if (minute / 10 == 0){
            dateString += "0"
        }
        dateString += "\(minute)"
        return dateString
    }


}
