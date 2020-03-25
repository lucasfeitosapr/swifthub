//
//  ViewController.swift
//  Swifthub
//
//  Created by Lucas Feitosa on 25/03/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RepositoryServiceDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  reposToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  reposToShow[indexPath.row].name
        return cell
    }
    
    //Setting up segmented control.
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
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var repositories: [RepositoryModel] = []
    
    var savedRepos: [RepositoryModel] = []
    
    var repositoryService = RepositoryService()
    
    //Array responsible for showing items on screen.
    lazy var reposToShow = repositories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func didUpdateRepositories(repositories: [RepositoryModel]){
        self.repositories = repositories
//        tableView.reloadData()
    }
    


}

