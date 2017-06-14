//
//  MyDataViewController.swift
//  HyuJokbo
//
//  Created by 박한솔 on 2017. 6. 7..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class MyDataViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
   
    @IBOutlet weak var MyTableView: UITableView!
    @IBOutlet weak var MyBookedTableView: UITableView!
    @IBOutlet weak var viewComment: UILabel!
    @IBOutlet weak var viewLike: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myImageButton: UIButton!
    @IBOutlet weak var myName: UILabel!
    
    var ref: FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?

    let user = User()
   
    var userLike = 0
    var userComment = 0
    
    var MyJokbo : [Jokbo] = []
    var BookedJokbo : [Jokbo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(g_CurUser.image == ""){
        myImage.image = #imageLiteral(resourceName: "icon-mydata")
        }else {
            self.imageLoad()
        }

        myImage.isUserInteractionEnabled = false
        myImage.backgroundColor = UIColor.clear
        if let userID = FIRAuth.auth()?.currentUser{
            user.email = userID.email!
        }
        if let index = user.email.range(of: "@")?.lowerBound{
            myName.text = user.email.substring(to: index)
        }else{
            myName.text = user.email
        }
        MyTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        MyTableView.delegate = self
        MyTableView.dataSource = self;
        
        MyBookedTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        MyBookedTableView.delegate = self
        MyBookedTableView.dataSource = self;
        
        // Do any additional setup after loading the view.
        ref = FIRDatabase.database().reference()

        databaseHandle = ref?.child("bookmarked").observe(.childAdded, with: { (snapshot) in
            let data = snapshot.value as? [String:String]
            if let BookmarkedData = data{
                if BookmarkedData["user"] == self.user.email{
                    for i in 0...(g_JokbosArray.count - 1){
                        guard let Boookedkey = BookmarkedData["key"]else{
                            break
                        }
                        if g_JokbosArray[i].key == Boookedkey{
                            print("key complete" )
                            print(g_JokbosArray[i].professorName)
                            self.BookedJokbo.append(g_JokbosArray[i])
                            break
                        }
                    }
                }
            }
            print(self.BookedJokbo.count)
            self.MyBookedTableView.reloadData()
        })
        
        databaseHandle = ref?.child("bookmarked").observe(.childChanged, with: { (snapshot) in
            let data = snapshot.value as? [String:String]
            if let BookmarkedData = data{
                if BookmarkedData["user"] == self.user.email{
                    print(BookmarkedData["key"])
                    for i in 0...(g_JokbosArray.count - 1){
                        if g_JokbosArray[i].key == BookmarkedData["key"]!{
                            print("key complete" )
                            print(g_JokbosArray[i].professorName)
                            self.BookedJokbo.append(g_JokbosArray[i])
                            break
                        }
                    }
                }
            }
            print(self.BookedJokbo.count)
            self.MyBookedTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func JokboLike () -> (){
         userLike = 0
        if g_JokbosArray.count > 0 {
            for i in 1...g_JokbosArray.count {
                let temp_jokbo = g_JokbosArray[i-1]
                if(temp_jokbo.userName == user.email){
                    userLike += temp_jokbo.likeNum
                }
            }
        }
    }
    
    func goohaeLike () -> (){
        if g_GoohaesArray.count > 0 {
            for i in 1...g_GoohaesArray.count {
                let temp_goohae = g_GoohaesArray[i-1]
                if(temp_goohae.userName == user.email){
                    userLike += temp_goohae.likeNum
                }
            }
        }
    }
    func JokboComment () -> (){
        userComment = 0;
        if g_JokbosArray.count > 0 {
            for i in 1...g_JokbosArray.count {
                let temp_jokbo = g_JokbosArray[i-1]
                if(temp_jokbo.userName == user.email){
                    userComment += temp_jokbo.commentNum
                }
            }
        }
    }
    
    func goohaeComment () -> (){
        if g_GoohaesArray.count > 0 {
            for i in 1...g_GoohaesArray.count {
                let temp_goohae = g_GoohaesArray[i-1]
                if(temp_goohae.userName == user.email){
                    userComment += temp_goohae.commentNum
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        JokboLike()
        goohaeLike()
        JokboComment()
        goohaeComment()
        MyJokboLoad()
        self.MyTableView.reloadData()
        viewLike.text = String(userLike)
        viewComment.text = String(userComment)
        //viewComment.text = String(userComment)
    }
    
    func MyJokboLoad(){
        self.MyJokbo = g_JokbosArray.filter{$0.userName == self.user.email}
        }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.MyTableView{
            return MyJokbo.count
        }
        else{
            return BookedJokbo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = UITableViewCell()
        if tableView != self.MyTableView {
            if let myBCell = tableView.dequeueReusableCell(withIdentifier: "MyDataBookCell", for: indexPath) as? MyDataBookTableViewCell{
                let jokbo = self.BookedJokbo[indexPath.row]
                myBCell.NumofCell?.text = String(indexPath.row+1)
                myBCell.SubjectName?.text  = String(jokbo.className)
                myBCell.ProfessorName?.text = String(jokbo.professorName)
                myBCell.LikeNum?.text = String(jokbo.likeNum)
                myBCell.CommentNum?.text = String(jokbo.commentNum)
                myBCell.BookmarkNum?.text = String(jokbo.bookmarkNum)
                return myBCell
            }

        }
        if let myBCell = tableView.dequeueReusableCell(withIdentifier: "MyDataJokboCell", for: indexPath) as? MyDataTableViewCell{
            let jokbo = self.MyJokbo[indexPath.row]
            myBCell.NumofTableLabel?.text = String(indexPath.row+1)
            myBCell.SubjectLabel?.text  = String(jokbo.className)
            myBCell.ProfessorLabel?.text = String(jokbo.professorName)
            myBCell.LikeNumLabel?.text = String(jokbo.likeNum)
            myBCell.CommentNumLabel?.text = String(jokbo.commentNum)
            myBCell.BookMarkNumLabel?.text = String(jokbo.bookmarkNum)
            return myBCell
        }
        
        return myCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyJokboSegue" {
            if let destination = segue.destination as? ViewJokboTableViewController, let selectedIndex = self.MyTableView.indexPathForSelectedRow?.row {
                
                destination.jokbo = MyJokbo[selectedIndex]
                g_SelectedData = MyJokbo[selectedIndex].key
            }
        }
        if segue.identifier == "BookedJokboSegue" {
            if let destination = segue.destination as? ViewJokboTableViewController, let selectedIndex = self.MyBookedTableView.indexPathForSelectedRow?.row {
                destination.jokbo = self.BookedJokbo[selectedIndex]
                g_SelectedData = self.BookedJokbo[selectedIndex].key
            }
        }
    }

    //MAKR: profile image
    func imageLoad(){

        if var url = URL(string: g_CurUser.image){
            var request = URLRequest(url:url)

            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    let newImage = UIImage(data:data!)
                        self.myImage.image = newImage

                }
                if(error != nil){
                    print(error)
                }
            }).resume()

        }
    }
    @IBAction func profileImagePick(_ sender: Any) {

        let p_picker = UIImagePickerController()
        p_picker.delegate = self
        p_picker.allowsEditing = false

        myImageButton.translatesAutoresizingMaskIntoConstraints = false
        myImageButton.centerXAnchor.constraint(equalTo: self.myImage.centerXAnchor).isActive = true
        myImageButton.topAnchor.constraint(equalTo: self.myImage.topAnchor, constant: 0).isActive = true
        myImageButton.widthAnchor.constraint(equalToConstant: self.myImage.frame.width).isActive = true
        myImageButton.heightAnchor.constraint(equalToConstant: self.myImage.frame.height).isActive = true

        present(p_picker, animated: true, completion: nil)

    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        myImage.contentMode = .scaleAspectFit
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImageToStorage(image: image)
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImageToStorage(image: image)
        } else{
            print("Something went wrong")
        }


        self.dismiss(animated: true, completion: nil)
    }

    func addImageToStorage(image:UIImage){
        var storageRef:FIRStorageReference
        var imageName = ""
        myImage.image = image

        imageName = g_CurUser.uid


        storageRef = FIRStorage.storage().reference().child(imageName)

        guard var uploadData = UIImageJPEGRepresentation(image, 0.1) else{

            return
        }
        //0.0~1.0 means quality of image

        storageRef.put(uploadData, metadata: nil, completion: {(metadata,error)
            in
            if  error != nil{
                print(error)
                return
            }

            if let downloadURL = metadata?.downloadURL(){
                g_CurUser.image = "\(downloadURL)"
                print("URL!!")
                print(downloadURL)

            }
        })
        var userImageRef = ref?.child("users").child(g_CurUser.uid).child("image")
        userImageRef?.setValue(g_CurUser.image)


    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {

        self.dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
