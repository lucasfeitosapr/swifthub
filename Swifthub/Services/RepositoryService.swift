//
//  RepositoryService.swift
//  Swifthub
//
//  Created by Lucas Feitosa on 25/03/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import Foundation

protocol RepositoryServiceDelegate{
    func didUpdateRepositories(repositories: [RepositoryModel])
}

struct RepositoryService{
    
    let gitHubUrl = "https://api.github.com/search/repositories?q=language:Swift&sort=stars"
    
    var delegate: RepositoryServiceDelegate?
    
    func fetchRepositories(){
        if let url = URL(string: gitHubUrl) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let repositories = self.parseJSON(repositoryData: safeData){
                        self.delegate?.didUpdateRepositories(repositories: repositories)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func parseJSON(repositoryData: Data) -> [RepositoryModel]? {
        let decoder = JSONDecoder()
        do {
            var repositoriesModel = [RepositoryModel]()
            let decodedData = try decoder.decode(Items.self, from: repositoryData)
            for repository in decodedData.items{
                let repositoryModel = RepositoryModel(name: repository.name, full_name: repository.full_name, url: repository.url, description: repository.description)
                repositoriesModel.append(repositoryModel)
            }
             
            return repositoriesModel
            

        } catch {
            print(error)
            return nil
        }
    }
    
    
}
