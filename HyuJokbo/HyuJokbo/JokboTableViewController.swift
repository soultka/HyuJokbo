//
//  JokboTableViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase



class JokboTableViewController: UITableViewController, JokboDownload, UISearchBarDelegate {

    var ref:FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?
    var databaseChangeHandle:FIRDatabaseHandle?
    var databaseRemoveHandle:FIRDatabaseHandle?

    var jokbosArray:[Jokbo] = []

    var commentsData: [String:Comment] = [:]
    var commentsArray: [Comment] = []

    var searchBar:UISearchBar!
    var searchBarOpenedBeforeSegue:Bool = false
    
    let placeholderColor = UIColor(red: 131/255, green: 154/255, blue: 213/255, alpha: 1.0)

    //서치 버튼이 표시되었을 경우 1, 표시 안되어 있을 경우 0
    static var searchPressedFlag = 0

    @IBAction func handleModalClose(segue: UIStoryboardSegue){
        self.jokbosArray = g_JokbosArray
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        print(g_CurUser.rcvLikeNum)
        self.setupSearchBar()
        self.searchBar.isHidden = true
        self.jokbosArray = g_JokbosArray

        //- -   -   -   -   -   -   -   -   -   -   DATA READING-
        ref = FIRDatabase.database().reference()
        //Retrieve the posts and listen for changes

        databaseHandle = ref?.child("jokbos").observe(.childAdded, with: { (snapshot) in
            //Take the value from the snapshot and added it to the jokbosData array
            let data = snapshot.value as? [String:String]

            if let jokboData = data{
                //Append the data to our jokbo array
                var jokbo = Jokbo()

                if let className = jokboData["className"],
                let jokboText = jokboData["jokboText"],
                let professorName = jokboData["professorName"],
                let updateDate = jokboData["updateDate"] ,
                let likeNum = jokboData["likeNum"],
                let userName = jokboData["userName"],
                let commentNum = jokboData["commentNum"],
                let bookmarkNum = jokboData["bookmarkNum"]{
                    jokbo = Jokbo(key: snapshot.key,
                                  className: className,
                                  jokboText: jokboText,
                                  professorName: professorName,
                                  updateDate: Int(updateDate)!,
                                  userName: userName,
                                  likeNum: Int(likeNum)!,
                                  commentNum: Int(commentNum)!,
                                  bookmarkNum: Int(bookmarkNum)!)
                    g_JokbosData[snapshot.key] = jokbo
                    g_JokbosArray = Array(g_JokbosData.values)
                    //reload the tableview
                    g_JokbosArray.sort{
                        $0.updateDate > $1.updateDate
                    }
                    if(self.searchBar.isHidden == true) {self.jokbosArray = g_JokbosArray}
                    self.tableView.reloadData()
                }

            }

        })

        databaseChangeHandle = ref?.child("jokbos").observe(.childChanged, with: { (snapshot) in
            //Take the value from the snapshot and added it to the gJokbosData array

            let data = snapshot.value as? [String:String]

            if let jokboData = data{
                //Append the data to our jokbo array

                var jokbo = Jokbo()

                if let className = jokboData["className"],
                    let jokboText = jokboData["jokboText"],
                    let commentNum = jokboData["commentNum"],
                    let likeNum = jokboData["likeNum"],
                    let professorName = jokboData["professorName"],
                    let updateDate = jokboData["updateDate"] ,
                    let userName = jokboData["userName"],
                    let bookmarkNum = jokboData["bookmarkNum"]{
                    jokbo = Jokbo(key: snapshot.key,
                                  className: className,
                                  jokboText: jokboText,
                                  professorName: professorName,
                                  updateDate: Int(updateDate)!,
                                  userName: userName,
                                  likeNum: Int(likeNum)!,
                                  commentNum: Int(commentNum)!,
                                  bookmarkNum: Int(bookmarkNum)!)
                    g_JokbosData[snapshot.key] = jokbo
                    g_JokbosArray = Array(g_JokbosData.values)
                    //reload the tableview
                    g_JokbosArray.sort{
                        $0.updateDate > $1.updateDate
                    }
                    if(self.searchBar.isHidden == true) {self.jokbosArray = g_JokbosArray}
                    self.tableView.reloadData()

                }
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


        let rowCount = jokbosArray.count
        return rowCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        let cell = tableView.dequeueReusableCell(withIdentifier: "JokboCell", for: indexPath) as! JokboTableViewCell

        let jokboDataShow = jokbosArray[indexPath.row]
        //jokbos로 부터 jokbo를 받아옴
        
        if let index = jokboDataShow.userName.range(of: "@")?.lowerBound{
            cell.UserNameLabel?.text = jokboDataShow.userName.substring(to: index)
        }else{
            cell.UserNameLabel?.text = jokboDataShow.userName
        }
        cell.key = jokboDataShow.key
        cell.SubjectLabel?.text = jokboDataShow.className
        cell.ProfessorLabel?.text = jokboDataShow.professorName
        cell.LikeNumLabel?.text = String(jokboDataShow.likeNum)
        cell.CommentNumLabel?.text = String(jokboDataShow.commentNum)
        cell.BookMarkNumLabel?.text = String(jokboDataShow.bookmarkNum)
        cell.DateLabel?.text = viewDate(date: jokboDataShow.updateDate)
        
        cell.downloadDelegate = self
        

        return cell
    }


    override func viewDidAppear(_ animated: Bool) {
        if(self.searchBarOpenedBeforeSegue == true)
        {
            self.searchBar.isHidden = false
            searchBarOpenedBeforeSegue = false
        }
        super.viewDidAppear(animated)
//        self.jokbosArray = g_JokbosArray
        self.tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        ref?.removeObserver(withHandle: databaseHandle!)
        ref?.removeObserver(withHandle: databaseChangeHandle!)

        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    func download(subjectName: String, key: String) {
        //to do list
        //다운로드 만들것
        let alertMessage = "<" + subjectName + ">\n의 족보를 다운받으시겠습니까?"
        let downloadAlert = UIAlertController(title: "족보 다운로드", message: alertMessage, preferredStyle: .alert)
        
        let downloadAction = UIAlertAction(title: "다운로드", style: .default) { (action: UIAlertAction) in
            
            let myImageName = "down" + subjectName
            
            self.databaseHandle = self.ref?.child("jokbo_images").observe(.childAdded, with: { (snapshot) in
                let data = snapshot.value as? [String:String]
                if snapshot.key == key{
                    if let image_Data = data{
                        for i in stride(from: 0, to: g_MAX_JOKBO_NUM, by: 1){
                            if let image_url = image_Data["j\(i)"]{
                                print(image_url)
                                let url = URL(string: image_url)
                                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                    DispatchQueue.main.async {
                                        if let jokboImage = UIImage(data: data!){
                                            CustomPhotoAlbum.sharedInstance.save(image: jokboImage)
                                        }
                                    }
                                }).resume()
                            }else{
                                break
                            }
                        }
                    }
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { (action: UIAlertAction) in
            downloadAlert.dismiss(animated: true, completion: nil)
        }

        downloadAlert.addAction(downloadAction)
        downloadAlert.addAction(cancelAction)
        
        self.present(downloadAlert, animated: true, completion: nil)
    }



    //MARK: prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JokboSegue" {
            if let destination = segue.destination as? ViewJokboTableViewController, let selectedIndex = self.tableView.indexPathForSelectedRow?.row {

                destination.jokbo = jokbosArray[selectedIndex]
                g_SelectedData = jokbosArray[selectedIndex].key
            }
        }
        if(self.searchBar.isHidden == false)
        {
            searchBarOpenedBeforeSegue = true
            self.searchBar.isHidden = true
        }else{
            searchBarOpenedBeforeSegue = false
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
            jokbosArray = g_JokbosArray
        }else{
        filterTableView(index: 0, text: searchText)
        }
        self.tableView.reloadData()
    }
    func filterTableView(index:Int, text:String){

            jokbosArray = g_JokbosArray.filter{$0.className.contains(text)}
            jokbosArray += g_JokbosArray.filter{$0.professorName.contains(text)}

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        jokbosArray = g_JokbosArray
        self.tableView.reloadData()
        self.searchBar.isHidden = true
    }
}
