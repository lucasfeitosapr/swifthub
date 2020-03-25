//
//  RepoModel.swift
//  Swifthub
//
//  Created by Lucas Feitosa on 25/03/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

struct Items: Decodable{
    let items: [RepositoryData]
}

struct RepositoryData: Decodable{
    let name: String
    let full_name: String
    let url: String
    let description: String
    
}


