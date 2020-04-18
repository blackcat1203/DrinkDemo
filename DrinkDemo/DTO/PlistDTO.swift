//
//  PlistDTO.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/13.
//  Copyright © 2020 Leon. All rights reserved.
//

//import Foundation

struct DrinkList:Codable {
    let drinkName:String
    let description:String
    let middlePrice:Int
    let bigPrice:Int?
    let image:String
}
