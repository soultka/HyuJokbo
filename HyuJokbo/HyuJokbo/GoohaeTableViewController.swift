//
//  GoohaeTableViewController.swift
//  HyuGoohae
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import QuartzCore
import FirebaseDatabase


class GoohaeTableViewController: UITableViewController,GoohaeDownload, UISearchBarDelegate {

    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    var databaseChangeHandle:FIRDatabaseHandle?
    var databaseRemoveHandle:FIRDatabaseHandle?

    var goohaesArray:[Goohae] = []

    let placeholderColor = UIColor(red: 131/255, green: 154/255, blue: 213/255, alpha: 1.0)
    //검색창 서브뷰
    var searchBar:UISearchBar!


    @IBAction func handleModalClose(segue: UIStoryboardSegue){
        self.goohaesArray = g_GoohaesArray

    }


    override func viewDidLoad() {
        super.viewDidLoad()


        self.setupSearchBar()
        self.searchBar.isHidden = true
         self.goohaesArray = g_GoohaesArray

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
                    if(self.searchBar.isHidden == true){self.goohaesArray = g_GoohaesArray}
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
                    if(self.searchBar.isHidden == true){ self.goohaesArray = g_GoohaesArray}
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

        let rowCount = self.goohaesArray.count
        return rowCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "GoohaeCell", for: indexPath) as! GoohaeTableViewCell

        if indexPath.row == 0 {
            var topLineView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(view.bounds.size.width), height: CGFloat(1)))
            topLineView.backgroundColor = UIColor.gray
            cell.contentView.addSubview(topLineView)
        }
        var bottomLineView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(cell.bounds.size.height), width: CGFloat(view.bounds.size.width), height: CGFloat(1)))
        bottomLineView.backgroundColor = UIColor.gray
        cell.contentView.addSubview(bottomLineView)

        let goohaeDataShow = self.goohaesArray[indexPath.row]
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
         self.goohaesArray = g_GoohaesArray
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

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "JokboAutoUploadSegue" {
            if let uploadButton = sender as? UIButton {
                let cell = uploadButton.superview?.superview as! UITableViewCell
                let indexPath = self.tableView.indexPath(for: cell)
                
                if let destination = segue.destination as? UINavigationController {
                    let targetController = destination.topViewController as? JokboUploadViewController
                    targetController?.passedClassName = self.goohaesArray[(indexPath?.row)!].className
                    targetController?.passedProfessorName = self.goohaesArray[(indexPath?.row)!].professorName
                }
            }
        } else if segue.identifier == "GoohaeSegue" {
            if let destination = segue.destination as? ViewGoohaeTableViewController, let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                    destination.goohae = self.goohaesArray[selectedIndex]
                    g_SelectedData = self.goohaesArray[selectedIndex].key
                    print("구해요", g_SelectedData)
            }
        }
    }
    

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPoint = self.navigationController?.navigationBar.frame.minY
        let subviewCGSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
        searchBar.frame = CGRect(x: scrollView.contentOffset.x, y: yPoint!, width: subviewCGSize.width, height: subviewCGSize.height)

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

    //MARK: Search Bar
    // 버튼 클릭시 호출
    @IBAction func SearchBarButtonPressed(_ sender: Any) {
        self.searchBar.isHidden = self.searchBar.isHidden ? false : true
    }

    func setupSearchBar(){
        let yPoint = self.navigationController?.navigationBar.frame.minY
        searchBar = UISearchBar(frame: CGRect(x: 0, y: yPoint!, width: UIScreen.main.bounds.width, height: 44))
        searchBar.showsCancelButton = true
        searchBar.barTintColor = UIColor(red: 76/255, green: 118/255, blue: 201/255, alpha: 1.0)
        
        let cancelButtonAttributes: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor(red: 213/255, green: 223/255, blue: 243/255, alpha: 1.0)]
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 64/255, green: 100/255, blue: 170/255, alpha: 1.0)
        textFieldInsideSearchBar?.attributedPlaceholder = NSAttributedString(string: "과목명 또는 교수님명을 입력하세요", attributes: [NSForegroundColorAttributeName: placeholderColor])
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        
        let glassIconView = textFieldInsideSearchBar?.leftView as! UIImageView
        glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        glassIconView.tintColor = UIColor(red: 213/255, green: 223/255, blue: 243/255, alpha: 1.0)
        
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor(red: 213/255, green: 223/255, blue: 243/255, alpha: 1.0)
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)

        
        searchBar.delegate = self
        self.navigationController?.view.addSubview(searchBar)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            goohaesArray = g_GoohaesArray
        }else{
            filterTableView(index: searchSelectedScope(rawValue: searchBar.selectedScopeButtonIndex)!, text: searchText)
        }
        self.tableView.reloadData()
    }
    func filterTableView(index:searchSelectedScope, text:String){
        switch index {
        case .subject:
            goohaesArray = g_GoohaesArray.filter{$0.className.contains(text)}
            goohaesArray += g_GoohaesArray.filter{$0.professorName.contains(text)}
        default:
            print("filterTable default")
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchBar.isHidden = true
    }
}
