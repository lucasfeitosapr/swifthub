//
//  RepositoryPullData.swift
//  Swifthub
//
//  Created by Lucas Feitosa on 26/03/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

struct RepositoryPullDataItems: Decodable{
    var repositoryPulls: [RepositoryPullData]
}


struct RepositoryPullData: Decodable{
    var title: String
}
