//
//  GoogleSheetDTO.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/13.
//  Copyright © 2020 Leon. All rights reserved.
//

//import Foundation

struct Group:Codable {
    let groupId:String
    let name:String
    let status:String
}


struct CreateGroup:Codable {
    var data:[Group]
}

struct Order:Codable {
    let orderId:String?
    let groupId:String?
    let name:String
    let drink:String
    let size:String
    let sugar:String
    let ice:String
    let add:String
    let price:String
}

struct CreateOrder:Codable {
    var data:[Order]
}

struct CUDReturn:Codable { //Create Update Delete
    let updated:Int?
    let created:Int?
    let deleted:Int?
    let error:String?
}

struct GetCount:Codable {
    let rows:Int?
    let error:String?
}
