//
//  Data.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 25..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import Foundation

//"g_" means global variable
var g_JokbosData = [String:Jokbo]()
var g_JokbosArray = [Jokbo]()

var g_GoohaesData = [String:Goohae]()
var g_GoohaesArray:[Goohae] = []

var g_CurUser = User()
let g_MAX_JOKBO_NUM = 30

var g_SelectedData:String = ""


class Jokbo{
    var key:String = ""
    var className:String = ""
    var jokboText:String = ""
    var professorName:String = ""
    var images:[String] = []
    var comments:[Comment] = []

    var updateDate:Int = 0

    var userName:String = ""
    var uid:String = ""
    var likeNum:Int = 0
    var commentNum:Int = 0
    var bookmarkNum:Int = 0
    
    init() {
    }

    convenience init(key:String, className:String, jokboText:String, professorName:String, updateDate:Int, userName:String ,uid:String ,likeNum:Int, commentNum:Int, bookmarkNum:Int) {
        self.init()
        self.key = key
        self.className = className
        self.jokboText = jokboText
        self.professorName = professorName
        self.updateDate = updateDate
        self.userName = userName
        self.uid = uid
        self.likeNum = likeNum
        self.commentNum = commentNum
        self.bookmarkNum = bookmarkNum
    }


}

class Goohae{
    var key:String = ""

    var className:String = ""
    var goohaeText:String = ""
    var professorName:String = ""
    var images:[String] = []
    var comments:[Comment] = []

    var updateDate:Int = 0

    var userName:String = ""
    var uid:String = ""
    var likeNum:Int = 0
    var commentNum:Int = 0
    var bookmarkNum:Int = 0
    
    init() {
    }

    convenience init(key:String, className:String, goohaeText:String, professorName:String, updateDate:Int, userName:String,uid:String,likeNum:Int, commentNum:Int, bookmarkNum:Int) {
        self.init()
        self.key = key
        self.className = className
        self.goohaeText = goohaeText
        self.professorName = professorName
        self.updateDate = updateDate
        self.userName = userName
        self.uid = uid
        self.likeNum = likeNum
        self.commentNum = commentNum
        self.bookmarkNum = bookmarkNum
    }
}

class Comment{
    var userName: String = ""
    var updateDate: String = ""
    var commentContent: String = ""
    var uploadID: String = ""
    
    init() {
    }
    
    convenience init(userName:String, updateDate:String, commentContent:String, uploadID: String){
        self.init()
        self.userName = userName
        self.updateDate = updateDate
        self.commentContent = commentContent
    }
}

class User{

    
    var uid:String = ""
    var image:String = ""
    var email:String = ""

    var sndLikeJokbo:[String] = [] //족보 ID들 담음
    var sndUploadJokbo:[String] = [] //족보 ID들 담음
    var sndBookmarkJokbo:[String] = [] // 족보 ID들 담음

    var rcvLikeNum:Int = 0
    var rcvCommentNum:Int = 0

    init() {
    }

    convenience init(uid:String){
        self.init()
        self.uid = uid
    }
}
