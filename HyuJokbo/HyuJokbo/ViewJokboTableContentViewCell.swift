//
//  ViewJokboTableContentViewCell.swift
//  HyuJokbo
//
//  Created by Jiwon Shin on 2017. 6. 1..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import UIKit

class ViewJokboTableContentViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var JokboImage: UIImageView!
    @IBOutlet weak var ContentLabel: UILabel!
    
    @IBOutlet weak var slideScroll: UIScrollView!
    @IBOutlet weak var PageControl: UIPageControl!
    //for scroll
    let scrollViewWidth = CGFloat(160)
    let scrollViewHeight = CGFloat(199)
    let jokboWidth = CGFloat(160)
    let jokboHeight = CGFloat(199)
    var jokboImages = [UIImageView](repeating: UIImageView(), count: 20)
//        var jokboImages = [UIImageView]()
    var imageCount:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfScrollViewElements() -> Int {
        return self.imageCount
    }

    func elementAtScrollViewIndex(index: Int) -> UIImageView {

        return jokboImages[index]
    }

    func setUpScroll(){
        //Make UIScrollView and setting
        slideScroll.showsHorizontalScrollIndicator = false
        slideScroll.isDirectionalLockEnabled = true
        slideScroll.isMultipleTouchEnabled = false
        slideScroll.isPagingEnabled = true

        slideScroll.delegate = self

        PageControl.numberOfPages = self.numberOfScrollViewElements()

    }
    func reloadScroll(){


        //xOffset is x offset for each jokbo
        var xOffset:CGFloat = 0
        for index in 0..<self.numberOfScrollViewElements(){
            let view = self.elementAtScrollViewIndex(index: index)

            view.frame = CGRect(x: xOffset, y: CGFloat(0),
                                width: jokboWidth, height: jokboHeight)


            xOffset = xOffset + jokboWidth


            slideScroll.addSubview(view)

        }
        if(self.imageCount > 0){

        self.JokboImage.isHidden = true
    }
        slideScroll.contentSize = CGSize(width: xOffset, height:scrollViewHeight)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        PageControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollViewWidth)
        self.reloadScroll()
    }


}
