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
    var GoohaesData = [[String:String]]()

    //서치 버튼이 표시되었을 경우 1, 표시 안되어 있을 경우 0
    static var searchPressedFlag = 0

    //스크롤을 아래로 내리면 리프레쉬뷰가 나오도록하는 클래스
    var refresh = UIRefreshControl()

    //검색창 서브뷰
    var searchSubView:UIView!


    @IBAction func handleModalClose(segue: UIStoryboardSegue){


    }


    override func viewDidLoad() {
        super.viewDidLoad()

        //테이블 뷰의 왼쪽위 좌표를 CGPoint로 얻어옴
        let topOfTableCGPoint = self.tableView.topAnchor.accessibilityActivationPoint
        //서브뷰(검색창)의 CGSize를 얻어옴
        let subviewCGSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        //얻어온 값을 기준으로 검색창 서브뷰 설정
        searchSubView = SearchView(frame:CGRect(origin: topOfTableCGPoint, size: subviewCGSize))

        self.tableView.addSubview(refresh)
        //검색창 서브뷰 추가
        self.view.addSubview(searchSubView)
        //검색창 서브뷰 기본적으로 숨겨짐
        self.searchSubView.isHidden = true


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        ref = FIRDatabase.database().reference()
        //Retrieve the posts and listen for changes

        databaseHandle = ref?.child("Goohaes").observe(.childAdded, with: { (snapshot) in
            //Take the value from the snapshot and added it to the GoohaesData array
            let Goohae = snapshot.value as? [String:String]
            if let actualGoohae = Goohae{
                //Append the data to our Goohae array

                self.GoohaesData.append(actualGoohae)
                //reload the tableview
                self.tableView.reloadData()
            }

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

        let rowCount = GoohaesData.count
        return rowCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "GoohaeCell", for: indexPath) as! GoohaeTableViewCell
        print(GoohaesData)
        var GoohaeDataShow = GoohaesData[indexPath.row]
        //Goohaes로 부터 Goohae를 받아옴
        guard let Goohae = GoohaeDataShow["GoohaeText"]  else {
            return cell
        }
        if let subject = GoohaeDataShow["className"] {
            cell.SubjectLabel?.text = subject
        }

        if let professor = GoohaeDataShow["professorName"] {
            cell.ProfessorLabel?.text = professor
        }

        cell.downloadDelegate = self


        return cell
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

            GoohaeTableViewController.searchPressedFlag = 0

        }else {
            //검색창이 표시안되있을경우
            self.tableView.reloadData()

            self.searchSubView.isHidden = false

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

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
