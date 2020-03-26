//
//  ViewController.swift
//  Swifthub
//
//  Created by Lucas Feitosa on 25/03/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RepositoryServiceDelegate{
    
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var repositories: [RepositoryModel] = []
    
    var savedRepos: [RepositoryModel] = []
    
    var repositoryService = RepositoryService()
    
    //Array responsible for showing items on screen.
    lazy var reposToShow = repositories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    /**
     Delegate responsible for updating the repositories array.
     @param: repositories it receives a list of repositories.
            
     */
    func didUpdateRepositories(repositories: [RepositoryModel]){
        self.repositories = repositories
        
        // TODO: Fix view not updating.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            self.tableView.reloadData()
            
        })
    }
    
    //-------------------Setup TableView----------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Called did selected row")
        let repoDetail = RepoDetailsViewController(selectedRepo: reposToShow[indexPath.row])
        navigationController?.pushViewController(repoDetail, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  reposToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  reposToShow[indexPath.row].name
        return cell
    }
    //-------------------End of Setup TableView----------------------------
    
    //-------------------Setup SegmentedControl----------------------------
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Repositories - Cloud","Repositories - Saved"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    
    @objc fileprivate func handleSegmentChange(){
        print(segmentedControl.selectedSegmentIndex)
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
             reposToShow = savedRepos
        default:
             reposToShow = repositories
        }
        
        tableView.reloadData()
    }
    //-------------------End of Setup SegmentedControl----------------------------
    
    
    /**
    Simple method to setup view.
               
    */
    
    func setupView(){
        repositoryService.delegate = self
        repositoryService.fetchRepositories()
        
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .white
        navigationItem.title = "Swifthub"
        
        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
        paddedStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
        
        let stackView = UIStackView(arrangedSubviews: [
            paddedStackView, tableView
        ])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .zero)
    }

}

