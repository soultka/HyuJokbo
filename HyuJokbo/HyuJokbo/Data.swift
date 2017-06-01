//
//  Data.swift
//  HyuJokbo
//
//  Created by ByoungWook Park on 2017. 5. 25..
//  Copyright © 2017년 박한솔. All rights reserved.
//

import Foundation


class Jokbo{
    var key:String = ""
    var userName:String = "익명"

    var className:String = ""
    var jokboText:String = ""
    var professorName:String = ""
    var images:[String] = []
    var comments:[String] = []

    var updateDate:Int = 0
    var like:Int = 0
    var hate:Int = 0


    init() {
    }

    convenience init(key:String, className:String, jokboText:String, professorName:String, updateDate:Int, userName:String) {
        self.init()
        self.key = key
        self.className = className
        self.jokboText = jokboText
        self.professorName = professorName
        self.updateDate = updateDate
        self.userName = userName
    }

}

class Goohae{
    var key:String = ""
    var userName:String = "익명"

    var className:String = ""
    var goohaeText:String = ""
    var professorName:String = ""
    var images:[String] = []
    var comments:[String] = []

    var updateDate:Int = 0
    var like:Int = 0
    var hate:Int = 0

    init() {
    }

    convenience init(key:String, className:String, jokboText:String, professorName:String, updateDate:Int, userName:String) {
        self.init()
        self.key = key
        self.className = className
        self.goohaeText = jokboText
        self.professorName = professorName
        self.updateDate = updateDate
        self.userName = userName
    }
}


class User{

    var name:String = ""
    var email:String = ""
    var jokbos:[Jokbo] = []
    var goohaes:[Goohae] = []

    var like:Int = 0
    var hate:Int = 0

}
