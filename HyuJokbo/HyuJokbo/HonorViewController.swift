//
//  HonorViewController.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 18..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class HonorViewController: UIViewController, UIScrollViewDelegate, HonorMemberButtonDelegate, UITableViewDataSource, UITableViewDelegate{

    var superViewWidth:CGFloat!
    var superViewHeight:CGFloat!
    var scrollViewY:CGFloat!
    var scrollViewWidth:CGFloat!
    var scrollViewHeight:CGFloat!
    var buttonWidth:CGFloat!
    var buttonHeight:CGFloat!
    var memberImageWidth:CGFloat!
    let PADDING = CGFloat(10)

    var imageViews:[HonorMemberImageView] = []
    @IBOutlet weak var slideScroll: HorizontalScrollView!
    @IBOutlet weak var CenterMemberLabel: UILabel!

    @IBOutlet weak var InvisibleScroll: UIScrollView!

    @IBOutlet weak var HonorJokboTableView: UITableView!
    @IBOutlet weak var HonorGoohaeTableView: UITableView!

    //- -   -   -   -   -   Honor Jokbos
    var honorJokbos:[Jokbo] = []
    var honorGoohaes:[Goohae] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        superViewWidth = self.view.frame.height
        superViewHeight = self.view.frame.height
        scrollViewY = CGFloat(100)
        scrollViewWidth = CGFloat(300)
        scrollViewHeight = CGFloat(100)
        buttonWidth = CGFloat(100)
        buttonHeight = CGFloat(100)
        memberImageWidth = CGFloat(70)

        self.CenterMemberLabel.text = "Member 1"



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
        scrollViewDidScroll(InvisibleScroll)
        self.HonorJokboTableView.reloadData()
        self.HonorGoohaeTableView.reloadData()
        honorGoohaeLoad()
        honorJokboLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfScrollViewElements() -> Int {
        return 10
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

        if(scrollView == InvisibleScroll || scrollView == slideScroll)
        {
            slideScroll.contentOffset = InvisibleScroll.contentOffset

            let index = Int((Double(slideScroll.contentOffset.x)/Double(buttonWidth)).rounded()) + 1
            print("moved \(Int(slideScroll.contentOffset.x)/Int(buttonWidth))")
            self.CenterMemberLabel.text = "Member\(index)"

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

        //xOffset is x offset for each button
        var xOffset:CGFloat = 0
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


    /// -   -   -   -   -   -   --  -   -   -   -TABLE VIEW
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

}
