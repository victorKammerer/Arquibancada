//
//  Login.swift
//  Arquibancada Watch App
//
//  Created by aaav on 25/11/22.
//

import Foundation

struct User : Decodable{
    let id = UUID()
    var status : String
    var message : String
    var data : Token
}
