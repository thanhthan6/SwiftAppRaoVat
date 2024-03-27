//
//  City.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/30/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import Foundation

struct CityPostRoute:Decodable{
    var kq:Int
    var list:[City]
}

struct City:Decodable{
    var _id: String
    var Name:String
    
    init(id:String, name:String) {
        self._id = id
        self.Name = name
    }
}
