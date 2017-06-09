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
    var scrollViewWidth = CGFloat(0)
    let scrollViewHeight = CGFloat(380)
    let jokboWidth = CGFloat(160)
    let jokboHeight = CGFloat(199)
    var jokboImages = [UIImageView](repeating: UIImageView(), count: 20)
    var currentPage:Int = 0
//        var jokboImages = [UIImageView]()
    var imageCount:Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.scrollViewWidth = self.frame.width
        self.PageControl?.isHidden = true
        self.PageControl?.numberOfPages = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func numberOfScrollViewElements() -> Int {
        return self.imageCount
    }

    func elementAtScrollViewIndex(index: Int) -> UIView {

        let view = UIScrollView()
        let jokboImage = jokboImages[index]
        if(jokboImage.image == nil){ return UIView()}

        view.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                            width: scrollViewWidth, height: scrollViewHeight)

        let imageXMulti = Double(view.frame.width)/Double(jokboImage.frame.size.width)
        let imageYMulti = Double(view.frame.height)/Double(jokboImage.frame.size.height)
        let multi = min(imageXMulti, imageYMulti)


        view.addSubview(jokboImage)
        //for zooming
        view.minimumZoomScale = 1.0
        view.maximumZoomScale = 2.5
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = false
        view.showsVerticalScrollIndicator = true
//        view.flashScrollIndicators()
        view.clipsToBounds = true
        view.delegate = self
        jokboImage.layer.cornerRadius = 11.0
        jokboImage.clipsToBounds = true


//         jokboImage.frame.size = CGSize(width: (jokboImage.image?.size.width)!, height: (jokboImage.image?.size.height)!)

        jokboImage.translatesAutoresizingMaskIntoConstraints = false
        jokboImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        jokboImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        jokboImage.widthAnchor.constraint(equalToConstant: CGFloat(Double(jokboImage.frame.width) * multi)).isActive = true
        jokboImage.heightAnchor.constraint(equalToConstant: CGFloat(Double(jokboImage.frame.height) * multi) - CGFloat(15)).isActive = true
        return view
    }

    func setUpScroll(){
        //Make UIScrollView and setting
        slideScroll.showsHorizontalScrollIndicator = false
         slideScroll.showsVerticalScrollIndicator = false
        slideScroll.isDirectionalLockEnabled = true
        slideScroll.isMultipleTouchEnabled = false
        slideScroll.isPagingEnabled = true

        slideScroll.delegate = self
        slideScroll.translatesAutoresizingMaskIntoConstraints = false
        slideScroll.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        slideScroll.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        slideScroll.widthAnchor.constraint(equalToConstant: scrollViewWidth).isActive = true
        slideScroll.heightAnchor.constraint(equalToConstant: scrollViewHeight).isActive = true
        
        

        PageControl?.numberOfPages = self.numberOfScrollViewElements()
        
        PageControl?.translatesAutoresizingMaskIntoConstraints = false
        PageControl?.centerXAnchor.constraint(equalTo: slideScroll.centerXAnchor).isActive = true
        PageControl?.topAnchor.constraint(equalTo: slideScroll.bottomAnchor, constant: 8).isActive = true
        PageControl?.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(100)).isActive = true
        PageControl?.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        self.bringSubview(toFront: PageControl)

    }
    func reloadScroll(){

        if(self.imageCount <= 0){ return }
        //xOffset is x offset for each jokbo
        var xOffset:CGFloat = 0
        for index in 0..<self.numberOfScrollViewElements(){
            let view = self.elementAtScrollViewIndex(index: index)

            view.frame = CGRect(x: xOffset, y: CGFloat(0),
                                width: scrollViewWidth, height: scrollViewHeight)


            xOffset = xOffset + scrollViewWidth


            slideScroll.addSubview(view)

        }
        if(self.JokboImage != nil){ self.JokboImage.isHidden = true}
        self.PageControl.isHidden = false
        slideScroll.contentSize = CGSize(width: xOffset, height:scrollViewHeight)
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == slideScroll){

        PageControl.currentPage = Int(scrollView.contentOffset.x)/Int(scrollViewWidth)
        }
//        self.reloadScroll()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = PageControl.currentPage

    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return jokboImages[self.currentPage]
    }




}
