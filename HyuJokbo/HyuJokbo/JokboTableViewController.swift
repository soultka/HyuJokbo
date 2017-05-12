//
//  JokboTableViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

//plist에서 데이터를 불러오기위한 변수들
let JokboFileName = "DataCenter"
var jokbos : Array<AnyObject> = []

class JokboTableViewController: UITableViewController,JokboDownload {


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
        let subviewCGSize = CGSize(width: 320, height: 568)
        //얻어온 값을 기준으로 검색창 서브뷰 설정
       searchSubView = SearchView(frame:CGRect(origin: topOfTableCGPoint, size: subviewCGSize))

        self.tableView.addSubview(refresh)
        //검색창 서브뷰 추가
        self.view.addSubview(searchSubView)
        //검색창 서브뷰 기본적으로 숨겨짐
        self.searchSubView.isHidden = true

        //DataCenter.plist주소를 jokboURL로 얻어옴
        guard let jokboURL = Bundle.main.url(forResource: JokboFileName, withExtension: "plist") else{
            print("No file")
            return
        }

        //jokboURL로 부터 자료를 Array로 캐스팅 후 jokboArray로 받아옴, 이를 jokbos에 저장
        if let jokboArray = NSArray(contentsOf : jokboURL)
        {
            print(jokboArray)
            jokbos += jokboArray as Array
        }


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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        let rowCount = jokbos.count
        return rowCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "JokboCell", for: indexPath) as! JokboTableViewCell

        //jokbos로 부터 jokbo를 받아옴
        guard let jokbo = jokbos[indexPath.row] as? [String:AnyObject] else {
            return cell
        }

        if let subject = jokbo["subject"] as? String{
            cell.SubjectLabel?.text = subject
        }

        if let professor = jokbo["professor"] as? String{
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
        if(JokboTableViewController.searchPressedFlag == 1)
        {

            self.tableView.reloadData()

            self.searchSubView.isHidden = true

            JokboTableViewController.searchPressedFlag = 0

        }else {
        //검색창이 표시안되있을경우
            self.tableView.reloadData()

            self.searchSubView.isHidden = false

            JokboTableViewController.searchPressedFlag = 1

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
