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

    @IBOutlet weak var JokboLabel: UILabel!
    @IBOutlet weak var SearchTextLabel: UITextField!
    static var searchPressedFlag = 0

    @IBAction func handleModalClose(segue: UIStoryboardSegue){
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.SearchTextLabel.isHidden = true

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
        return jokbos.count
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

    func download() {
        print("Downloading...")
    }

    @IBAction func SearchBarButtonPressed(_ sender: Any) {



        if(JokboTableViewController.searchPressedFlag == 0){
            self.navigationItem.title = ""
            self.SearchTextLabel.isHidden = false
            self.JokboLabel.isHidden = true
            JokboTableViewController.searchPressedFlag = 1;
        }else{
            self.navigationItem.title = ""
            self.SearchTextLabel.isHidden = true
            self.JokboLabel.isHidden = false
            JokboTableViewController.searchPressedFlag = 0;
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
