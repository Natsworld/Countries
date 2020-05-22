//
//  CountriesdataModel.swift
//  Countries
//
//  Created by admin on 21/05/20.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation

class CountriesdataModel:Codable
{
    let name: String
    let flag: String
    let region: String
    let subregion: String
    let capital: String
    let callingCodes: [String]
    let timezones: [String]
    let languages: [Language]
    let currencies: [Currency]
//    var name : String
//    var flag : String
//    var capital : String
//    var region : String
//    var subregion : String
//    var timezones : [String]
//    var Language : [Language]
//    var currencies :[Currency]
}

class Language:Codable
{
    var name : String
}

class Currency : Codable
{
    var code : String?
    let name: String?
}
