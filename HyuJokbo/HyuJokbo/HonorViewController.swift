//
//  HonorViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HonorViewController: UIViewController, UIScrollViewDelegate, HonorMemberButtonDelegate, UITableViewDataSource, UITableViewDelegate{

    var superViewWidth:CGFloat!
    var superViewHeight:CGFloat!
    var scrollViewY:CGFloat!
    var scrollViewWidth:CGFloat!
    var scrollViewHeight:CGFloat!
    var buttonWidth:CGFloat!
    var buttonHeight:CGFloat!
    var memberImageWidth:CGFloat!
    var scrollIndex:Int = 1
    var imageLoadCnt = 0
    let PADDING = CGFloat(10)

    var ref: FIRDatabaseReference?



    var imageViews:[HonorMemberImageView] = []
    @IBOutlet weak var slideScroll: UIScrollView!
    @IBOutlet weak var CenterMemberLabel: UILabel!
    @IBOutlet weak var RcvLike: UILabel!
    @IBOutlet weak var RcvComment: UILabel!

    @IBOutlet weak var InvisibleScroll: UIScrollView!

    @IBOutlet weak var HonorJokboTableView: UITableView!
    @IBOutlet weak var HonorGoohaeTableView: UITableView!

    //- -   -   -   -   -   Honor Jokbos
    var honorUsers = HonorUser()
    var honorJokbos:[Jokbo] = []
    var honorGoohaes:[Goohae] = []

    override func viewDidLoad() {
        ref = FIRDatabase.database().reference()
        self.loadHonorUsers()

        super.viewDidLoad()


        superViewWidth = self.view.frame.height
        superViewHeight = self.view.frame.height
        scrollViewY = CGFloat(100)
        scrollViewWidth = CGFloat(300)
        scrollViewHeight = CGFloat(100)
        buttonWidth = CGFloat(100)
        buttonHeight = CGFloat(100)
        memberImageWidth = CGFloat(70)




        //For ScrollView---
        setUpScroll()
        reloadScroll()


        scrollViewDidScroll(InvisibleScroll)



        //For TableView
        HonorJokboTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        HonorGoohaeTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        // Do any additional setup after loading the view.
        self.honorJokboLoad()
        self.honorGoohaeLoad()

        HonorJokboTableView.delegate = self
        HonorJokboTableView.dataSource = self
        //        HonorJokboTableView.register(HonorJokboTableViewCell.self, forCellReuseIdentifier: "HonorJokboCell")

        HonorGoohaeTableView.delegate = self
        HonorGoohaeTableView.dataSource = self
        //        HonorGoohaeTableView.register(HonorGoohaeTableViewCell.self, forCellReuseIdentifier: "HonorGoohaeCell")




    }
    override func viewDidAppear(_ animated: Bool) {
        self.imageLoadCnt = 0
        scrollViewDidScroll(InvisibleScroll)
        self.setupHonorUsers()
        self.loadHonorUsers()

        self.HonorJokboTableView.reloadData()
        self.HonorGoohaeTableView.reloadData()
        honorGoohaeLoad()
        honorJokboLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: -   -   -   -   -   -   Load HonorUsers
    func setupHonorUsers(){

        for i in stride(from: 0, to: g_MAX_HONOR_USER_NUM, by: 1){

            ref?.child("honor_users").child("\(i+1)").observeSingleEvent(of:.value, with: { (snapshot) in

                g_HonorUsers.members[i].uid = snapshot.value as! String
            })
        }
    }
    func loadHonorUsers(){

        for user in g_HonorUsers.members{

            if user.uid != ""{

                ref?.child("users").child(user.uid).observeSingleEvent(of:.value, with: { (snapshot) in


                    if var indexOfUser = g_HonorUsers.members.index(where: { (item) -> Bool in
                        item.uid == user.uid
                    }){
                        if let email = snapshot.childSnapshot(forPath: "email").value as? String{
                            g_HonorUsers.members[indexOfUser].email = email

                        }
                        if let image = snapshot.childSnapshot(forPath: "image").value as? String{
                            g_HonorUsers.members[indexOfUser].image = image

                        }

                        if let rcvLikeNum = snapshot.childSnapshot(forPath: "rcvLikeNum").value as? String{
                            g_HonorUsers.members[indexOfUser].rcvLikeNum = Int(rcvLikeNum)!



                        }
                        if let rcvCommentNum = snapshot.childSnapshot(forPath: "rcvCommentNum").value as? String{
                            g_HonorUsers.members[indexOfUser].rcvCommentNum = Int(rcvCommentNum)!

                        }

                    }
                    g_HonorUsers.members.sort(by: {$0.rcvLikeNum > $1.rcvLikeNum })

                    self.reloadLabels()
//                    self.sortG_Honor()
//                    self.loadAllImages()

                })
            }

        }


    }
    func loadAllImages(){

        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        for user in g_HonorUsers.members{

            pthread_mutex_trylock(&mutex)
            if var indexOfUser = g_HonorUsers.members.index(where: { (item) -> Bool in
                item.uid == user.uid
            }){
                if(indexOfUser <= g_MAX_HONOR_USER_NUM){
                    if user.uid != ""{
                        //image load
                        if var url = URL(string: g_HonorUsers.members[indexOfUser].image){
                            var request = URLRequest(url:url)

                            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                                DispatchQueue.main.async {
                                    let newImage = UIImage(data:data!)
                                    self.imageViews[indexOfUser].image = newImage

                                }
                                if(error != nil){
                                    print(error)
                                }
                                if(user.image.isEmpty){
                                    self.imageViews[indexOfUser].image = nil
                                    self.imageViews[indexOfUser].image = UIImage(named: "icon-h_mydata(b)")


                                }

                            }).resume()



                        }
                    }
                    if(user.image.isEmpty){

                        self.imageViews[indexOfUser].image = UIImage(named: "icon-h_mydata(b)")


                    }
                }
            }
            pthread_mutex_unlock(&mutex)

        }
        self.sortG_Honor()



    }
    func sortG_Honor() {
        g_HonorUsers.members.sort(by: {$0.rcvLikeNum > $1.rcvLikeNum })

        g_HonorUsers.maxLike = g_HonorUsers.members[0].rcvLikeNum
        g_HonorUsers.minLike = g_HonorUsers.members[g_MAX_HONOR_USER_NUM-1].rcvLikeNum
        var isPossibleToSort = 1
        for i in stride(from: 0, to: g_MAX_HONOR_USER_NUM-1, by: 1){
            if g_HonorUsers.members[i].uid == "" {
                isPossibleToSort = 0
            }
        }
        if isPossibleToSort == 1{
        for i in stride(from: 0, to: g_MAX_HONOR_USER_NUM-1, by: 1){
            self.ref?.child("honor_users").child("\(i+1)").setValue(g_HonorUsers.members[i].uid)
        }
        }
    }


    //MARK: -   -   -   -   -   -   -   -   -   -Scroll!!!!!!VIEW
    func numberOfScrollViewElements() -> Int {
        return g_MAX_HONOR_USER_NUM
    }


    func elementAtScrollViewIndex(index: Int) -> UIButton {

        let button = HonorMemberButton()
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)

        if(button.imageAddedFlag == 0){
            let imageView = HonorMemberImageView(image: UIImage(named: "icon-h_mydata(b)"))
            imageViews.insert(imageView,at:index)

            let slideInt = Int(slideScroll.contentOffset.x)
            let scrollViewWidth  = Int(self.scrollViewWidth)
            let intxoffset = imageViews[index].xOffsetOfSuper
            let ButtonWidth = Int(self.buttonWidth)

            let differency = (slideInt + scrollViewWidth/2) - (intxoffset + ButtonWidth/2)
            imageViews[index].width = Int(memberImageWidth) - (abs(differency))/4
            imageViews[index].height = imageViews[index].width

            imageViews[index].frame = CGRect(x: (Int(buttonWidth) - imageViews[index].width)/2,
                                             y: (Int(buttonHeight) - imageViews[index].height)/2,
                                             width: imageViews[index].width,
                                             height: imageViews[index].height)
            button.addSubview(imageViews[index])
            button.imageAddedFlag = 1
        }
        button.delegate = self

        return button
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if(self.imageLoadCnt <= 2){

            loadAllImages()
            self.imageLoadCnt += 1
        }

        if(scrollView == InvisibleScroll || scrollView == slideScroll)
        {
            slideScroll.contentOffset = InvisibleScroll.contentOffset

            self.scrollIndex = (Int((Double(slideScroll.contentOffset.x)/Double(buttonWidth)).rounded()) + 1)
            let index = self.scrollIndex

            //            print("moved \(Int(slideScroll.contentOffset.x)/Int(buttonWidth))")

            self.reloadLabels()

            //Dynamic image size
            for index in stride(from: 0, to: self.numberOfScrollViewElements(), by: 1)
            {
                let slideInt = Int(slideScroll.contentOffset.x)
                let scrollViewWidth  = Int(self.scrollViewWidth)
                let intxoffset = imageViews[index].xOffsetOfSuper
                let ButtonWidth = Int(self.buttonWidth)

                let differency = (slideInt + scrollViewWidth/2) - (intxoffset + ButtonWidth/2)
                imageViews[index].width = Int(memberImageWidth) - (abs(differency))/4
                imageViews[index].height = imageViews[index].width
                imageViews[index].frame = CGRect(x: (Int(buttonWidth) - imageViews[index].width)/2,
                                                 y: (Int(buttonHeight) - imageViews[index].height)/2,
                                                 width: imageViews[index].width,
                                                 height: imageViews[index].height)

            }
        }

    }
    func reloadLabels(){
        if(self.scrollIndex > 0  && self.scrollIndex <= g_MAX_HONOR_USER_NUM){
            if let index = g_HonorUsers.members[self.scrollIndex-1].email.range(of: "@")?.lowerBound {
                self.CenterMemberLabel.text = g_HonorUsers.members[self.scrollIndex-1].email.substring(to: index)
            }
            self.RcvLike.text = String(g_HonorUsers.members[self.scrollIndex-1].rcvLikeNum)
            self.RcvComment.text = String(g_HonorUsers.members[self.scrollIndex-1].rcvCommentNum)


        }

    }


    func setUpScroll(){
        //Make UIScrollView and setting
        slideScroll.showsHorizontalScrollIndicator = false
        slideScroll.isDirectionalLockEnabled = true
        slideScroll.isMultipleTouchEnabled = false
        slideScroll.isPagingEnabled = false

        slideScroll.translatesAutoresizingMaskIntoConstraints = false
        slideScroll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        slideScroll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        slideScroll.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true
        slideScroll.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true

        InvisibleScroll.showsHorizontalScrollIndicator = false
        InvisibleScroll.isDirectionalLockEnabled = true
        InvisibleScroll.isPagingEnabled = true
        InvisibleScroll.isUserInteractionEnabled = false

        InvisibleScroll.translatesAutoresizingMaskIntoConstraints = false
        InvisibleScroll.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        InvisibleScroll.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        InvisibleScroll.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        InvisibleScroll.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true

        slideScroll.addGestureRecognizer(InvisibleScroll.panGestureRecognizer)

        InvisibleScroll.delegate = self
        self.view.bringSubview(toFront: slideScroll)

    }


    func reloadScroll(){


        for sub in slideScroll.subviews{
            sub.removeFromSuperview()
        }
        self.imageViews.removeAll()
        var xOffset:CGFloat = 0

        xOffset += buttonWidth
        //xOffset is x offset for each button

        for index in 0..<self.numberOfScrollViewElements(){
            let view = self.elementAtScrollViewIndex(index: index)

            view.frame = CGRect(x: xOffset, y: CGFloat(0),
                                width: buttonWidth, height: buttonHeight)

            imageViews[index].xOffsetOfSuper = Int(xOffset)
            xOffset = xOffset + buttonWidth

            slideScroll.addSubview(view)

        }
        slideScroll.contentSize = CGSize(width: xOffset + buttonWidth, height:scrollViewHeight)
        InvisibleScroll.contentSize = CGSize(width: xOffset - buttonWidth, height:scrollViewHeight)
        //        self.reloadLabels()


    }


    func HonorButtonTouchBegan() {
        slideScroll.isScrollEnabled = false
        slideScroll.isPagingEnabled = false
        scrollViewDidScroll(InvisibleScroll)

    }
    func HonorButtonGesture() {
        print(Int(InvisibleScroll.contentOffset.x)/Int(buttonWidth))
        slideScroll.isScrollEnabled = true
        slideScroll.isPagingEnabled = true

    }
    @IBAction func JokboMoreButton(_ sender: Any) {
        print("jokbo more")
        self.tabBarController?.selectedIndex = 0
    }

    @IBAction func GoohaeMoreButton(_ sender: Any) {
        print("goohae more")
        self.tabBarController?.selectedIndex = 1
    }


    //MARK: -   -   -   -   -   -   --  -   -   -   -TABLE VIEW
    func honorJokboLoad(){
        self.honorJokbos = g_JokbosArray.sorted{ $0.likeNum > $1.likeNum }
    }
    func honorGoohaeLoad(){
        if(!g_GoohaesArray.isEmpty){
            self.honorGoohaes = g_GoohaesArray.sorted{ $0.likeNum > $1.likeNum }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.HonorJokboTableView {
            return 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.HonorJokboTableView {
            return min(10, honorJokbos.count)

        } else {
            return min(10, honorGoohaes.count)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell()


        if tableView == self.HonorJokboTableView {
            if let myJCell = tableView.dequeueReusableCell(withIdentifier: "HonorJokboCell", for: indexPath) as? HonorJokboTableViewCell{
                let jokbo = self.honorJokbos[indexPath.row]

                myJCell.RankNumLabel?.text = String(indexPath.row+1)
                myJCell.SubjectLabel?.text = String(jokbo.className)
                myJCell.ProfessorLabel?.text = String(jokbo.professorName)
                myJCell.LikeNumLabel?.text = String(jokbo.likeNum)
                myJCell.CommentNumLabel?.text = String(jokbo.commentNum)
                myJCell.BookmarkNumLabel?.text = String(jokbo.bookmarkNum)

                return myJCell
            }
        }

        if tableView == self.HonorGoohaeTableView {
            if let myGCell = tableView.dequeueReusableCell(withIdentifier: "HonorGoohaeCell", for: indexPath) as? HonorGoohaeTableViewCell{
                let goohae = self.honorGoohaes[indexPath.row]
                
                myGCell.RankNumLabel?.text = String(indexPath.row+1)
                myGCell.SubjectLabel?.text = String(goohae.className)
                myGCell.ProfessorLabel?.text = String(goohae.professorName)
                myGCell.LikeNumLabel?.text = String(goohae.likeNum)
                myGCell.CommentNumLabel?.text = String(goohae.commentNum)
                myGCell.BookmarkNumLabel?.text = String(goohae.bookmarkNum)
                
                return myGCell
            }
            
        }
        
        return myCell
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "JokboSegue" {
            if let destination = segue.destination as? ViewJokboTableViewController, let selectedIndex = self.HonorJokboTableView.indexPathForSelectedRow?.row {
                
                destination.jokbo = honorJokbos[selectedIndex]
                g_SelectedData = honorJokbos[selectedIndex].key
            }
        }
        if segue.identifier == "GoohaeSegue" {
            if let destination = segue.destination as? ViewGoohaeTableViewController, let selectedIndex = self.HonorGoohaeTableView.indexPathForSelectedRow?.row {
                destination.goohae = self.honorGoohaes[selectedIndex]
                g_SelectedData = self.honorGoohaes[selectedIndex].key
            }
        }
    }
    
}
