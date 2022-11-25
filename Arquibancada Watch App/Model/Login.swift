//
//  Login.swift
//  Arquibancada Watch App
//
//  Created by aaav on 25/11/22.
//

import Foundation

struct Login : Decodable{
    let id = UUID()
    var status : String
    var data : Token
}

struct Token: Decodable {
    var token : String
}
