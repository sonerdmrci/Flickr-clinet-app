//
//  Photo.swift
//  FlickrClinetAppSwift
//
//  Created by Soner Demirci on 2.09.2023.
//

import Foundation

struct Photos: Codable{
    let page: Int?
    let pages: Int?
    let perpage:Int?
    let total:Int
    let photo:[Photo]?
}
