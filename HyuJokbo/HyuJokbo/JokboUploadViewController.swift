//
//  JokboUploadViewController.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Photos
import BSImagePicker
import FBSDKLoginKit
import FirebaseAuth

class JokboUploadViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var TitleTextView: UITextView!
    @IBOutlet weak var ProfessorTextView: UITextView!
    @IBOutlet weak var ContentTextView: UITextView!


    var ref: FIRDatabaseReference?

    var TitlePlaceholderLabel: UILabel!
    var ProfessorPlaceholderLabel: UILabel!
    var ContentPlaceholderLabel: UILabel!

    var selectedImages:[UIImage] = [] // photos
    var uploadImageURLs:[String] = []

    var passedClassName: String = ""
    var passedProfessorName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()



        ref = FIRDatabase.database().reference()

        self.TitleTextView.delegate = self
        self.ProfessorTextView.delegate = self
        self.ContentTextView.delegate = self

        if passedClassName.isEmpty == true {
            self.TitleTextView?.text = "수업명"
            self.TitleTextView?.textColor = UIColor.lightGray
        } else {
            self.TitleTextView?.text = passedClassName
        }
        
        if passedProfessorName.isEmpty == true {
            self.ProfessorTextView?.text = "교수님"
            self.ProfessorTextView?.textColor = UIColor.lightGray
        } else {
            self.ProfessorTextView?.text = passedProfessorName
        }

        
        self.TitleTextView.tag = 0
        self.ProfessorTextView.tag = 1
        self.ContentTextView.tag = 2
        
        self.ContentTextView?.text = "여기를 눌러서 글을 작성할 수 있습니다."
        self.ContentTextView?.textColor = UIColor.lightGray

        self.TitleTextView?.layer.borderWidth = 0.5
        self.TitleTextView?.layer.borderColor = UIColor.lightGray.cgColor
        self.ProfessorTextView?.layer.borderWidth = 0.5
        self.ProfessorTextView?.layer.borderColor = UIColor.lightGray.cgColor
        self.ContentTextView?.layer.borderWidth = 0.5
        self.ContentTextView?.layer.borderColor = UIColor.lightGray.cgColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.TitleTextView?.setContentOffset(CGPoint.zero, animated: false)
        self.ProfessorTextView?.setContentOffset(CGPoint.zero, animated: false)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView.tag == 0 {
                textView.text = "수업명"
            } else if textView.tag == 1 {
                textView.text = "교수님"
            } else if textView.tag == 2 {
                textView.text = "여기를 눌러서 글을 작성할 수 있습니다."
            }
            textView.textColor = UIColor.lightGray
        }
    }

    func dateString() -> String{
        var dateStr = ""
        let date = Date()

        let calendar = Calendar.current
        let component = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        dateStr += "\(component.year!)"
        if (component.month! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.month!)"
        if (component.day! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.day!)"
        if (component.hour! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.hour!)"
        if (component.minute! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.minute!)"
        if (component.second! / 10 == 0){
            dateStr += "0"
        }
        dateStr += "\(component.second!)"
        return dateStr
    }

    @IBAction func addJokbo(_ sender: Any) {
        // TODO: post the jokbo to firebase
        // TODO: post the jokbo to firebase
        if (self.TitleTextView?.text == "수업명") || (self.TitleTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "알림", message:
                "수업명을 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return

        } else if (self.ProfessorTextView?.text == "교수님") || (self.ProfessorTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "알림", message:
                "교수님명을 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        } else if (self.ContentTextView?.text == "여기를 눌러서 글을 작성할 수 있습니다.") || (self.ContentTextView?.text.isEmpty)! {
            let alertController = UIAlertController(title: "알림", message:
                "내용을 입력해주세요", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }

        var dateStr = ""

        dateStr += dateString()



        var curRef = self.ref?.child("jokbos").childByAutoId()

        if(selectedImages.isEmpty == false){
            let errorIndex = addPhoto(key: (curRef?.key)!)
            if errorIndex.isEmpty == false
            {
                var alertMessage:String = ""
                alertMessage += "\(errorIndex) "
                alertMessage += "번째 선택한 사진업로드에서 문제가 발생했습니다. 다른 사진을 선택해주세요"
                let alertController = UIAlertController(title: "알림", message:
                    alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }

        var userName:String = ""
        if let user = FIRAuth.auth()?.currentUser{
            userName += user.email!
        }

        curRef?.child("className").setValue(TitleTextView.text)
        curRef?.child("professorName").setValue(ProfessorTextView.text)
        curRef?.child("jokboText").setValue(ContentTextView.text)
        curRef?.child("updateDate").setValue(dateStr)
        curRef?.child("userName").setValue(userName)
        curRef?.child("likeNum").setValue("0")
        curRef?.child("commentNum").setValue("0")
        curRef?.child("bookmarkNum").setValue("0")

        if let user = FIRAuth.auth()?.currentUser {
            curRef?.child("userName").setValue(user.email)
        } else {
            curRef?.child("userName").setValue("admin")

        }

        // Dismiss the popover
        presentingViewController?.dismiss(animated: true, completion: nil)
    }



    @IBAction func photoUploadButton(_ sender: Any) {


        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 6

        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")

        }, deselect: { (asset: PHAsset) -> Void in
            print("Deselected: \(asset)")
        }, cancel: { (assets: [PHAsset]) -> Void in
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            for i in stride(from: 0, to: assets.count, by: 1){
                self.selectedImages += [self.getAssetThumbnail(asset: assets[i])]
            }
            print("Finish: \(assets)")
        }, completion: nil)

    }

    //Convert :PHAsset to :UIImage
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }

    func addPhoto(key:String) -> [Int]{

        var i:Int = 0   //Image counter
        var imageName:String
        var storageRef:FIRStorageReference
        var errorIndex:[Int] = []

        let curRef = ref?.child("jokbo_images").child(key)
        //        let curRef =
        //- -   -   -   -   -   -Exception handling
        for selected in selectedImages{
            imageName = key + "[\(i)].jpg"
            storageRef = FIRStorage.storage().reference().child(imageName)
            if var uploadData = UIImageJPEGRepresentation(selected, 0.1){
            }else if var uploadData = UIImagePNGRepresentation(selected) {
            }else{
                print("\(i)번째 이미지를 변환 중 실패하였습니다")
                errorIndex += [i]
            }
            i += 1
        }

        if(errorIndex.isEmpty == false){
            selectedImages.removeAll()
            return errorIndex
        }

        i=0
        for selected in selectedImages{
            imageName = key + "[\(i)].jpg"
            storageRef = FIRStorage.storage().reference().child(imageName)

            guard var uploadData = UIImageJPEGRepresentation(selected, 0.1) else{
                guard var uploadData = UIImagePNGRepresentation(selected) else{
                    return errorIndex
                }
                return errorIndex
            }

                //0.0~1.0 means quality of image
                storageRef.put(uploadData, metadata: nil, completion: {(metadata,error)
                    in
                    if  error != nil{
                        print(error)
                        return
                    }

                    if let downloadURL = metadata?.downloadURL(){

                        self.uploadImageURLs += ["\(downloadURL)"]
                        print("URL!!")
                        print(downloadURL)

                    }
                    if(i >= self.selectedImages.count-2){
                        self.uploadPhoto(curRef: curRef!)
                    }

                })

            i += 1
        }
        selectedImages.removeAll()
        return errorIndex
    }
    func uploadPhoto(curRef:FIRDatabaseReference){
        var count:Int = 0
        print("upupup")

        for imageURL in self.uploadImageURLs{
            let imageRef = curRef.child("j\(count)")
            imageRef.setValue(imageURL){(error) in
                //                print("Error while writing image to FIRdatabase")
            }
            count += 1
        }
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
