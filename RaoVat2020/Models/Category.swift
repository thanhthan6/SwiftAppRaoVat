//
//  Category.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/30/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import Foundation

struct CategoryPostRoute:Decodable{
    var kq:Int
    var CateList:[Category]
}

struct Category:Decodable{
    var _id: String
    var Name:String
    var Image:String
    
    init(id:String, name:String, image:String) {
        self._id = id
        self.Name = name
        self.Image = image
    }
}
