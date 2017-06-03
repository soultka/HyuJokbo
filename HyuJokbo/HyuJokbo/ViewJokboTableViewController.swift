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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()
        
        tableView.allowsSelection = false
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            return 10
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
            
            cell.CommentNumLabel?.text = String(jokbo.commentNum)
        
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewJokboContentCell", for: indexPath) as! ViewJokboTableContentViewCell
            databaseHandle = ref?.child("jokbo_images").observe(.childAdded, with: { (snapshot) in
                let data = snapshot.value as? [String:String]
                if snapshot.key == self.jokbo.key{
                    if let image_Data = data{
                        if let image_url = image_Data["j0"]{
                            print(image_url)
                            let url = URL(string: image_url)
                            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                DispatchQueue.main.async {
                                    cell.JokboImage?.image = UIImage(data: data!)
                                }
                            }).resume()
                        }
                    }
                }

                
            })
         //   cell.JokboImage?.image = UIimage[
            cell.ContentLabel?.text = jokbo.jokboText
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewJokboCommentCell", for: indexPath) as! ViewJokboTableCommentViewCell
            
            cell.UserInfoName?.text = "박병욱"
            cell.CommentInfoDate?.text = "2017.6.1 15:28"
            cell.CommentInfoComment?.text = "제발 되라어ㅏ리ㅓㅣㅁ러이"
            
            
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
            ref?.child("jokbos").child(jokbo.key).updateChildValues(["likeNum": "\(jokbo.likeNum+1)"])
            isLikeButtonTapped = true
            
            let likeButton = sender as? UIButton
            let jokboTableView = likeButton?.superview?.superview?.superview?.superview as! UITableView
            let indexPath = IndexPath(row: 0, section: 0)
            let titleCell = jokboTableView.cellForRow(at: indexPath) as? ViewJokboTableTitleViewCell
            titleCell?.LikeNumLabel?.text = String(jokbo.likeNum+1)
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
            ref?.child("jokbos").child(jokbo.key).updateChildValues(["bookmarkNum": "\(jokbo.bookmarkNum+1)"])
            isBookMarkButtonTapped = true
            
            let bookmarkButton = sender as? UIButton
            let jokboTableView = bookmarkButton?.superview?.superview?.superview?.superview as! UITableView
            let indexPath = IndexPath(row: 0, section: 0)
            let titleCell = jokboTableView.cellForRow(at: indexPath) as? ViewJokboTableTitleViewCell
            titleCell?.BookmarkNumLabel?.text = String(jokbo.bookmarkNum+1)
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
