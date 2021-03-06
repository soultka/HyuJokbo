//
//  GoohaeTableViewCell.swift
//  HyuGoohae
//
//  Created by ByoungWook Park on 2017. 5. 12..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

protocol GoohaeDownload{
    func download()
}

class GoohaeTableViewCell: UITableViewCell {

    @IBOutlet weak var SubjectLabel: UILabel!
    @IBOutlet weak var ProfessorLabel: UILabel!

    @IBOutlet weak var DownloadButtonImage: UIButton!

    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var LikeNumLabel: UILabel!
    @IBOutlet weak var CommentNumLabel: UILabel!
    @IBOutlet weak var BookMarkNumLabel: UILabel!
    var downloadDelegate : GoohaeDownload?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //다운로드 버튼이 눌러졌을 경우
    @IBAction func DownloadButtonPressed(_ sender: Any) {
        //icon-download(b)로 버튼을 바꿈
        let blueDownButton = UIImage(named: "icon-upload(b)")

        //DownloadButtonImage.setImage(blueDownButton, for: UIControlState.normal)

        DownloadButtonImage.imageView?.animationImages = [blueDownButton!]
        DownloadButtonImage.imageView?.animationDuration = 0.0
        DownloadButtonImage.imageView?.animationRepeatCount = 0
        DownloadButtonImage.imageView?.startAnimating()


    }

    //다운로드 버튼을 누른 후 땠을 경우
    @IBAction func DownloadButton(_ sender: Any) {
        //기본 아이콘인 icon-download로 버튼을 바꿈
        let blueDownButton = UIImage(named: "icon-upload(b)")
        let grayDownButton = UIImage(named: "icon-upload")

        downloadDelegate?.download()

        //DownloadButtonImage.setImage(blueDownButton, for: UIControlState.normal)


        DownloadButtonImage.imageView?.animationImages = [blueDownButton!,grayDownButton!]
        DownloadButtonImage.imageView?.animationDuration = 0.2
        DownloadButtonImage.imageView?.animationRepeatCount = 1
        DownloadButtonImage.imageView?.startAnimating()
        
        
        
    }
    
}
