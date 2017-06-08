//
//  JokboTableViewCell.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit
import FirebaseDatabase
protocol JokboDownload{
    func download()
}

class JokboTableViewCell: UITableViewCell {

    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var ProfessorLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var LikeNumLabel: UILabel!
    @IBOutlet weak var CommentNumLabel: UILabel!
    @IBOutlet weak var BookMarkNumLabel: UILabel!
    var key:String = ""

    @IBOutlet weak var DownloadButtonImage: UIButton!

    var downloadDelegate : JokboDownload?
    var ref: FIRDatabaseReference?
    var databaseHandle:FIRDatabaseHandle?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ref = FIRDatabase.database().reference()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //다운로드 버튼이 눌러졌을 경우
    @IBAction func DownloadButtonPressed(_ sender: Any) {
        //icon-download(b)로 버튼을 바꿈
        let blueDownButton = UIImage(named: "icon-download(b)")

        //DownloadButtonImage.setImage(blueDownButton, for: UIControlState.normal)

        DownloadButtonImage.imageView?.animationImages = [blueDownButton!]
        DownloadButtonImage.imageView?.animationDuration = 0.0
        DownloadButtonImage.imageView?.animationRepeatCount = 0
        DownloadButtonImage.imageView?.startAnimating()


    }

    //다운로드 버튼을 누른 후 땠을 경우
    @IBAction func DownloadButton(_ sender: Any) {
        //기본 아이콘인 icon-download로 버튼을 바꿈
        let blueDownButton = UIImage(named: "icon-download(b)")
        let grayDownButton = UIImage(named: "icon-download")

        downloadDelegate?.download()
        DownloadJokbo()

        //DownloadButtonImage.setImage(blueDownButton, for: UIControlState.normal)


        DownloadButtonImage.imageView?.animationImages = [blueDownButton!,grayDownButton!]
        DownloadButtonImage.imageView?.animationDuration = 0.2
        DownloadButtonImage.imageView?.animationRepeatCount = 1
        DownloadButtonImage.imageView?.startAnimating()



    }

    func DownloadJokbo(){
        let myImageName = "down\(self.SubjectLabel.text)"

        databaseHandle = ref?.child("jokbo_images").observe(.childAdded, with: { (snapshot) in
            let data = snapshot.value as? [String:String]
            if snapshot.key == self.key{
                if let image_Data = data{
                    for i in stride(from: 0, to: g_MAX_JOKBO_NUM, by: 1){
                        if let image_url = image_Data["j\(i)"]{
                            print(image_url)
                            let url = URL(string: image_url)
                            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                                DispatchQueue.main.async {
                                    CustomPhotoAlbum.sharedInstance.save(image: UIImage(data: data!)!)
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
    
}
