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
var g_GoohaesArray = [Goohae]()

class Jokbo{
    var key:String = ""
    var className:String = ""
    var jokboText:String = ""
    var professorName:String = ""
    var images:[String] = []
    var comments:[String] = []

    var updateDate:Int = 0

    var userName:String = ""
    var likeNum:Int = 0
    var commentNum:Int = 0
    var bookmarkNum:Int = 0
    
    init() {
    }

    convenience init(key:String, className:String, jokboText:String, professorName:String, updateDate:Int, userName:String ,likeNum:Int, commentNum:Int, bookmarkNum:Int) {
        self.init()
        self.key = key
        self.className = className
        self.jokboText = jokboText
        self.professorName = professorName
        self.updateDate = updateDate
        self.userName = userName
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
    var comments:[String] = []

    var updateDate:Int = 0

    var userName:String = ""
    var likeNum:Int = 0
    var commentNum:Int = 0
    var bookmarkNum:Int = 0
    
    init() {
    }

    convenience init(key:String, className:String, goohaeText:String, professorName:String, updateDate:Int, userName:String,likeNum:Int, commentNum:Int, bookmarkNum:Int) {
        self.init()
        self.key = key
        self.className = className
        self.goohaeText = goohaeText
        self.professorName = professorName
        self.updateDate = updateDate
        self.userName = userName
        self.likeNum = likeNum
        self.commentNum = commentNum
        self.bookmarkNum = bookmarkNum
    }
}


class User{
    
    var email:String = ""
    var jokbos:[Jokbo] = []
    var goohaes:[Goohae] = []

    var likeNum:Int = 0
    var commentNum:Int = 0
}
