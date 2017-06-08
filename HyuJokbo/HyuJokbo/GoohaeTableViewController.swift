//
//  GoohaeTableViewController.swift
//  HyuGoohae
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase

class GoohaeTableViewController: UITableViewController,GoohaeDownload {

    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    var databaseChangeHandle:FIRDatabaseHandle?
    var databaseRemoveHandle:FIRDatabaseHandle?

    //서치 버튼이 표시되었을 경우 1, 표시 안되어 있을 경우 0
    static var searchPressedFlag = 0

    //검색창 서브뷰
    var searchSubView:SearchView!


    @IBAction func handleModalClose(segue: UIStoryboardSegue){


    }


    override func viewDidLoad() {
        super.viewDidLoad()

        //- -   -   -   -   --  -   -   -   -   -   -   SEARCH VIEW ADD
        //테이블 뷰의 왼쪽위 좌표를 CGPoint로 얻어옴
        let topOfTableCGPoint = self.tableView.topAnchor.accessibilityActivationPoint
        //서브뷰(검색창)의 CGSize를 얻어옴
        let subviewCGSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        //얻어온 값을 기준으로 검색창 서브뷰 설정
        searchSubView = SearchView(frame:CGRect(origin: topOfTableCGPoint, size: subviewCGSize))

        //검색창 서브뷰 추가
        self.view.addSubview(searchSubView)
        //검색창 서브뷰 기본적으로 숨겨짐
        self.searchSubView.isHidden = true

        //- -   -   -   -   --  -   -   --  -   -   -   -   -DATA READ
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        ref = FIRDatabase.database().reference()
        //Retrieve the posts and listen for changes

        databaseHandle = ref?.child("goohaes").observe(.childAdded, with: { (snapshot) in
            //Take the value from the snapshot and added it to the goohaesData array
            let data = snapshot.value as? [String:String]

            if let goohaeData = data {
                var goohae = Goohae()
                
                if let className = goohaeData["className"],
                let goohaeText = goohaeData["goohaeText"],
                let professorName = goohaeData["professorName"],
                let updateDate = goohaeData["updateDate"] ,
                let likeNum = goohaeData["likeNum"],
                let userName = goohaeData["userName"],
                let commentNum = goohaeData["commentNum"],
                let bookmarkNum = goohaeData["bookmarkNum"]{
                    goohae = Goohae(key: snapshot.key,
                                    className: className,
                                    goohaeText: goohaeText,
                                    professorName: professorName,
                                    updateDate: Int(updateDate)!,
                                    userName: userName,
                                    likeNum: Int(likeNum)!,
                                    commentNum: Int(commentNum)!,
                                    bookmarkNum: Int(bookmarkNum)!)
                   g_GoohaesData[snapshot.key] = goohae
                    g_GoohaesArray = Array(g_GoohaesData.values)
                    //reload the tableview
                    g_GoohaesArray.sort{
                        $0.updateDate > $1.updateDate
                    }
                    self.tableView.reloadData()
                }
            }
        })

        databaseChangeHandle = ref?.child("goohaes").observe(.childChanged, with: { (snapshot) in
            //Take the value from the snapshot and added it to the goohaesData array
            let data = snapshot.value as? [String:String]
            
            if let goohaeData = data {
                var goohae = Goohae()
                
                if let className = goohaeData["className"],
                    let goohaeText = goohaeData["goohaeText"],
                    let professorName = goohaeData["professorName"],
                    let updateDate = goohaeData["updateDate"] ,
                    let likeNum = goohaeData["likeNum"],
                    let userName = goohaeData["userName"],
                    let commentNum = goohaeData["commentNum"],
                    let bookmarkNum = goohaeData["bookmarkNum"]{
                    goohae = Goohae(key: snapshot.key,
                                    className: className,
                                    goohaeText: goohaeText,
                                    professorName: professorName,
                                    updateDate: Int(updateDate)!,
                                    userName: userName,
                                    likeNum: Int(likeNum)!,
                                    commentNum: Int(commentNum)!,
                                    bookmarkNum: Int(bookmarkNum)!)
                    g_GoohaesData[snapshot.key] = goohae
                    g_GoohaesArray = Array(g_GoohaesData.values)
                    //reload the tableview
                    g_GoohaesArray.sort{
                        $0.updateDate > $1.updateDate
                    }
                    self.tableView.reloadData()
                }
            }

        })


        databaseRemoveHandle = ref?.child("goohaes").observe(.childRemoved, with: { (snapshot) in
            //Take the value from the snapshot and added it to the goohaesData array
            
            g_GoohaesData.removeValue(forKey: snapshot.key)
            //reload the tableview
            self.tableView.reloadData()
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        let rowCount = g_GoohaesData.count
        return rowCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "GoohaeCell", for: indexPath) as! GoohaeTableViewCell
        
        
        let goohaeDataShow = g_GoohaesArray[indexPath.row]
        //goohaes로 부터 goohae를 받아옴
        
        if let index = goohaeDataShow.userName.range(of: "@")?.lowerBound{
            cell.UserNameLabel?.text = goohaeDataShow.userName.substring(to: index)
        } else {
            cell.UserNameLabel?.text = goohaeDataShow.userName
        }

        cell.SubjectLabel?.text = goohaeDataShow.className
        cell.ProfessorLabel?.text = goohaeDataShow.professorName
        cell.LikeNumLabel?.text = String(goohaeDataShow.likeNum)
        cell.CommentNumLabel?.text = String(goohaeDataShow.commentNum)
        cell.BookMarkNumLabel?.text = String(goohaeDataShow.bookmarkNum)
        cell.DateLabel?.text = viewDate(date: goohaeDataShow.updateDate)

        cell.downloadDelegate = self

        return cell
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("disappearaaa")
        super.viewDidDisappear(animated)
        ref?.removeObserver(withHandle: databaseHandle!)
        ref?.removeObserver(withHandle: databaseChangeHandle!)
    }
    
    //Download 버튼 클릭시 호출
    func download() {
        //to do list
        //다운로드 만들것
        print("Downloading...")
    }

    @IBAction func SearchBarButtonPressed(_ sender: Any) {

        //검색창이 표시되었을 경우
        if(GoohaeTableViewController.searchPressedFlag == 1)
        {

            self.tableView.reloadData()

            self.searchSubView.isHidden = true

            //editing모드 초기화
            if self.searchSubView.SearchTextField.text != "검색어를 입력하세요"{
                self.searchSubView.SearchTextField.text = nil
                self.searchSubView.SearchTextField.endEditing(true)
            }


            GoohaeTableViewController.searchPressedFlag = 0

        }else {
            //검색창이 표시안되있을경우
            self.tableView.reloadData()

            self.searchSubView.isHidden = false
            //검색버튼을 닫을 경우 editing모드 초기화
            
            GoohaeTableViewController.searchPressedFlag = 1
            
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

    
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "JokboAutoUploadSegue" {
            if let uploadButton = sender as? UIButton {
                let cell = uploadButton.superview?.superview as! UITableViewCell
                let indexPath = self.tableView.indexPath(for: cell)
                
                if let destination = segue.destination as? UINavigationController {
                    let targetController = destination.topViewController as? JokboUploadViewController
                    targetController?.passedClassName = g_GoohaesArray[(indexPath?.row)!].className
                    targetController?.passedProfessorName = g_GoohaesArray[(indexPath?.row)!].professorName
                }
            }
        } else if segue.identifier == "GoohaeSegue" {
            if let destination = segue.destination as? ViewGoohaeTableViewController, let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.goohae = g_GoohaesArray[selectedIndex]
                    g_SelectedData = g_GoohaesArray[selectedIndex].key
                    print("구해요", g_SelectedData)
            }
        }
    }
    

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let subviewCGSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        searchSubView.frame = CGRect(origin: scrollView.contentOffset, size: subviewCGSize)
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
