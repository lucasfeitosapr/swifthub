//
//  RepositoryService.swift
//  Swifthub
//
//  Created by Lucas Feitosa on 25/03/20.
//  Copyright © 2020 Lucas. All rights reserved.
//
/**
 Class responsible for fetching the required info from the API.
 */

import Foundation

protocol RepositoryServiceDelegate{
    func didUpdateRepositories(repositories: [RepositoryModel])
    
}

protocol RepositoryServicePullDelegate {
    func didUpdateRepositoryPulls(repositoryPulls: [RepositoryPullModel])
}

struct RepositoryService{
    
    let gitHubUrl = "https://api.github.com/search/repositories?q=language:Swift&sort=stars"
    let pullsUrl = "http://api.github.com/repos/"
    
    var delegate: RepositoryServiceDelegate?
    var pullDelegate: RepositoryServicePullDelegate?
    
    
    func fetchRepositories(){
        if let url = URL(string: gitHubUrl) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let repositories = self.parseJSONRepositoryModel(repositoryData: safeData){
                        self.delegate?.didUpdateRepositories(repositories: repositories)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func fetchRepositoryPulls(fullName: String){
        if let url = URL(string: pullsUrl + fullName + "/pulls") {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let repositoryPull = self.parseJSONRepositoryPull(repositoryPullData: safeData){
                        self.pullDelegate?.didUpdateRepositoryPulls(repositoryPulls: repositoryPull)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func parseJSONRepositoryModel(repositoryData: Data) -> [RepositoryModel]? {
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
    
    func parseJSONRepositoryPull(repositoryPullData: Data) -> [RepositoryPullModel]? {
        let decoder = JSONDecoder()
        do {
            var repositoryPulls = [RepositoryPullModel]()
            let decodedData = try decoder.decode([RepositoryPullData].self, from: repositoryPullData)
            for repository in decodedData{
                print(repository)
                let repositoryModel = RepositoryPullModel(title: repository.title)
                repositoryPulls.append(repositoryModel)
            }
             
            return repositoryPulls
            
        } catch {
            print(error)
            return nil
        }
    }
    
    
}
