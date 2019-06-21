//
//  List.swift
//  l-tech.test
//
//  Created by Евгений on 20/06/2019.
//  Copyright © 2019 Евгений. All rights reserved.
//

import Foundation

class Post{
    
    var title: String
    var info: String
    var date: Date
    var pictureURL: URL
    var sort: Int
    
    init(title: String, info: String, pictureURL: URL, date: Date, sort: Int) {
        
        self.title = title
        self.info = info
        self.date = date
        self.pictureURL = pictureURL
        self.sort = sort

    }
}
