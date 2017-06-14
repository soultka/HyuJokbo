//
//  ViewJokboTableViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 6. 1..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ViewJokboTableViewController: UITableViewController {

    var ref: FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?

    var isLikeButtonTapped: Bool = false
    var isBookMarkButtonTapped: Bool = false
    var isSirenButtonTapped: Bool = false
    var jokbo = Jokbo()
    var jokboImages = [UIImageView](repeating: UIImageView(), count: 10)

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


        //검색창 서브뷰 추가
        self.view.addSubview(commentSubView)
        self.view.bringSubview(toFront: commentSubView)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    //MARK: Loading Animation

    override func viewDidAppear(_ animated: Bool) {
        scrollViewDidScroll((self.tableView as? UIScrollView)!)
        ref?.removeAllObservers()
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
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewJokboTitleCell", for: indexPath) as! ViewJokboTableTitleViewCell
        
           let Date = jokbo.updateDate
            
            // Configure the cell...
        
            if let index = jokbo.userName.range(of: "@")?.lowerBound{
                cell.UserInfoNameLabel?.text = jokbo.userName.substring(to: index)
            }else{
                cell.UserInfoNameLabel?.text = jokbo.userName
            }

            cell.SubjectLabel?.text = jokbo.className
            cell.ProfessorLabel?.text = jokbo.professorName
            cell.UserInfoUploadTime?.text = viewDate(date: Date)
            cell.CommentNumLabel?.text = String(commentsArray.count)
            
            if isLikeButtonTapped == false {
                cell.LikeNumLabel?.text = String(jokbo.likeNum)
            } else {
                cell.LikeNumLabel?.text = String(jokbo.likeNum+1)
            }
            
            if isBookMarkButtonTapped == false {
                cell.BookmarkNumLabel?.text = String(jokbo.bookmarkNum)
            } else {
                cell.BookmarkNumLabel?.text = String(jokbo.bookmarkNum+1)
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewJokboContentCell", for: indexPath) as! ViewJokboTableContentViewCell
            if(cell.imageCount  <= 0){
            databaseHandle = ref?.child("jokbo_images").observe(.childAdded, with: { (snapshot) in
                let dataaa = snapshot.value as? [String:String]
                let snapshotCnt = snapshot.childrenCount
                if snapshot.key == self.jokbo.key{
                    if let image_Data = dataaa{

                        for i  in stride(from: 0, to: Int(snapshotCnt), by: 1)
                        {
                        if var image_url = image_Data["j\(i)"]{
                            print(image_url)
                            if var url = URL(string: image_url){
                                var request = URLRequest(url:url)

                                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                                    DispatchQueue.main.async {
                                        let newImage = UIImageView()
                                        newImage.image = UIImage(data:data!)

//                                        cell.JokboImage.image = UIImage(data: data!)
                                        if( newImage.image != nil)
                                        {
                                            newImage.frame.size = CGSize(width: (newImage.image?.size.width)!, height: (newImage.image?.size.height)!)
                                        cell.jokboImages[i] = newImage
                                        cell.imageCount = Int(snapshotCnt)
                                        cell.setUpScroll()
                                        cell.reloadScroll()
                                        }

                                    }
                                    if(error != nil){
                                        print(error)
                                    }
                                }).resume()

                            }
                        }else{
                            //Image count over
//                            if(cell.imageCount > 0 ){ cell.imageCount = i}
                                cell.setUpScroll()
                                cell.reloadScroll()

                            break;
                            }

                        }

                    }
                }
                
                
            })
            }
         //   cell.JokboImage?.image = UIimage[
            if(cell.imageCount == 0){cell.loadingAni()}
            cell.ContentLabel?.text = jokbo.jokboText
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewJokboCommentCell", for: indexPath) as! ViewJokboTableCommentViewCell
            
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
    @IBAction func refreshBtn(_ sender: Any) {
        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
        
    }

    @IBAction func likeButtonTapped(_ sender: Any) {
        if g_CurUser.sndLikeJokbo.index(of: jokbo.key) != nil {
            let alertController = UIAlertController(title: "알림", message:
                "이미 추천한 게시물입니다.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            ref?.child("jokbos").child(jokbo.key).updateChildValues(["likeNum": "\(jokbo.likeNum+1)"])
            isLikeButtonTapped = true
            ref?.child("users").child(jokbo.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let rcvLikeNum = snapshot.childSnapshot(forPath: "rcvLikeNum").value as? String{
                    self.ref?.child("users").child(self.jokbo.uid).updateChildValues(["rcvLikeNum" : "\(Int(rcvLikeNum)! + 1)"])

                    var findInHonor = 0
                    for i in stride(from: 0, to: g_MAX_HONOR_USER_NUM-1, by: 1){
                        if(g_HonorUsers.members[i].uid == self.jokbo.uid){
                            findInHonor = 1
                        }
                    }
                    if(findInHonor == 0){
                        g_HonorUsers.members.sort(by: {$0.rcvLikeNum > $1.rcvLikeNum })
                        let minHonorUid = g_HonorUsers.members[4].uid
                        self.ref?.child("users").child(minHonorUid).child("rcvLikeNum").observeSingleEvent(of: .value, with: { (snapshot) in
                            let minLike = snapshot.value as! String
                            g_HonorUsers.minLike = Int(minLike)!
                            if(Int(rcvLikeNum)! + 1 > g_HonorUsers.minLike){
                                self.ref?.child("honor_users").child("5").setValue(self.jokbo.uid)
                            }
                            g_HonorUsers.members.sort(by: {$0.rcvLikeNum > $1.rcvLikeNum })

                        })
                    }



                    print("check")
                }
            })
            let likeButton = sender as? UIButton
            let jokboTableView = likeButton?.superview?.superview?.superview?.superview as! UITableView
            let indexPath = IndexPath(row: 0, section: 0)
                
            let titleCell = jokboTableView.cellForRow(at: indexPath) as? ViewJokboTableTitleViewCell
            var userRef = self.ref?.child("users").child(g_CurUser.uid).child("sndLikeJokbo")
            userRef?.childByAutoId().setValue(jokbo.key)   //유저의 좋아요 정보에 족보 키를 넣음
            g_CurUser.sndLikeJokbo += [jokbo.key]
            titleCell?.LikeNumLabel?.text = String(jokbo.likeNum+1)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        //업도르한 족보들의 키를 넣어놓음




    }
    
    @IBAction func bookmarkButtonTapped(_ sender: Any) {
        if g_CurUser.sndBookmarkJokbo.index(of: jokbo.key) != nil {
            let alertController = UIAlertController(title: "알림", message:
                "이미 스크랩한 게시물입니다.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            ref?.child("jokbos").child(jokbo.key).updateChildValues(["bookmarkNum": "\(jokbo.bookmarkNum+1)"])
            isBookMarkButtonTapped = true
            let curRef = ref?.child("bookmarked").childByAutoId()
            var userName:String = ""
            if let user = FIRAuth.auth()?.currentUser{
                userName += user.email!
            }
            curRef?.child("user").setValue(userName)
            curRef?.child("key").setValue(jokbo.key)
            
            let bookmarkButton = sender as? UIButton
            let jokboTableView = bookmarkButton?.superview?.superview?.superview?.superview as! UITableView
            let indexPath = IndexPath(row: 0, section: 0)
            let titleCell = jokboTableView.cellForRow(at: indexPath) as? ViewJokboTableTitleViewCell
            titleCell?.BookmarkNumLabel?.text = String(jokbo.bookmarkNum+1)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            var userRef = self.ref?.child("users").child(g_CurUser.uid).child("sndBookmarkJokbo")
            userRef?.childByAutoId().setValue(jokbo.key)   //유저의 좋아요 정보에 족보 키를 넣음
            g_CurUser.sndBookmarkJokbo += [jokbo.key]
        }
        //업도르한 족보들의 키를 넣어놓음
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
        if scrollView == self.tableView{
        let subviewPoint = CGPoint(x:scrollView.contentOffset.x,
                                   y:scrollView.contentOffset.y + self.tableView.frame.height - self.commentSubViewHeight)
            let subviewCGSize = CGSize(width: self.view.frame.width,
                                       height: self.commentSubViewHeight)
                    commentSubView.frame = CGRect(origin: subviewPoint, size: subviewCGSize)
        }

    }
    func viewDate(date DateNum:Int ) -> String{
        var dateString = ""
        var dateN = DateNum
        let year = dateN/10000000000
        dateString += "\(year)."
        dateN = dateN % 10000000000
        let month = dateN/100000000
        if (month / 10 == 0){
            dateString += "0"
        }
        dateString += "\(month)."
        dateN = dateN % 100000000
        let day = dateN / 1000000
        if (month / 10 == 0){
            dateString += "0"
        }
        dateString += "\(day) "
        dateN = dateN % 1000000
        let hour = dateN / 10000
        if (hour / 10 == 0){
            dateString += "0"
        }
        dateString += "\(hour):"
        dateN = dateN % 10000
        let minute = dateN / 100
        if (minute / 10 == 0){
            dateString += "0"
        }
        dateString += "\(minute)"
        return dateString
    }


}
