//
//  RepoDetailsViewController.swift
//  Swifthub
//
//  Created by Lucas Feitosa on 25/03/20.
//  Copyright © 2020 Lucas. All rights reserved.
//

/**
 This class is responsible for Repository Details that were selected on ViewController
 */

import UIKit

class RepoDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RepositoryServicePullDelegate {
    
    //-------------------Declarations----------------------------
    var pullsFromRepo: [RepositoryPullModel]
    
    var selectedRepo: RepositoryModel?
    
    var repositoryService = RepositoryService()
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details","Pulls"])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        return sc
    }()
    
    let repoNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Repo Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let repoDescription: UITextView = {
        let label = UITextView()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    let saveRepoButton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("SAVE REPO", for: UIControl.State())
           button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
           button.layer.borderWidth = 1
           button.layer.cornerRadius = 5
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
           return button
       }()
    //-------------------End of Declarations----------------------------
    
    init(selectedRepo: RepositoryModel) {
        self.selectedRepo = selectedRepo
        self.pullsFromRepo = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //-------------------Setup SegmentedView----------------------------
    @objc fileprivate func handleSegmentChange(){
        print(segmentedControl.selectedSegmentIndex)
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            
            repositoryService.fetchRepositoryPulls(fullName: selectedRepo!.full_name)
            tableView.frame = CGRect(x: segmentedControl.frame.minX, y: segmentedControl.frame.minY+300, width: 500, height: 500)
            view.addSubview(tableView)
            tableView.reloadData()
            
            
        default:
            tableView.removeFromSuperview()
        }
        
    }
    //-------------------End Setup SegmentedView----------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        repositoryService.pullDelegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        setupView()

    }
    
    //-------------------Setup TableView----------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  pullsFromRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  pullsFromRepo[indexPath.row].title
        return cell
    }
    
    //-------------------End Setup SegmentedView----------------------------
    
    
    func didUpdateRepositoryPulls(repositoryPulls: [RepositoryPullModel]) {
        self.pullsFromRepo = repositoryPulls
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            
            self.tableView.reloadData()
            
        })
        
    }
    
    
    /**
     
     Simple method to setup the elements from the view.
    
    */
    func setupView(){
        repositoryService.fetchRepositoryPulls(fullName: selectedRepo!.full_name)
        
        let paddedStackView = UIStackView(arrangedSubviews: [segmentedControl])
        paddedStackView.layoutMargins = .init(top: 12, left: 12, bottom: 12, right: 12)
        paddedStackView.isLayoutMarginsRelativeArrangement = true
        
        
        let stackView = UIStackView(arrangedSubviews: [
            paddedStackView
        ])
        
        repoNameLabel.text = selectedRepo?.name
        repoNameLabel.frame = CGRect(x: view.center.x/1.2, y: view.center.y/3.5, width: repoNameLabel.frame.width + 100, height: repoNameLabel.frame.height + 50)
        repoDescription.text = selectedRepo?.description
        repoDescription.frame = CGRect(x: segmentedControl.frame.minX+20, y: segmentedControl.frame.minY+350, width: 300, height: 200)
        
        saveRepoButton.frame = CGRect(x: repoDescription.frame.minX+100, y: repoDescription.frame.minY+225, width: 200, height: 50)
        
        stackView.axis = .vertical
        stackView.frame = CGRect(x: view.center.x/2, y: view.center.y/2, width: segmentedControl.frame.width + 100, height: segmentedControl.frame.height + 50)
        view.addSubview(repoNameLabel)
        view.addSubview(stackView)
        view.addSubview(dividerLineView)
        view.addSubview(saveRepoButton)
        view.addSubview(repoDescription)
    }
    

}
