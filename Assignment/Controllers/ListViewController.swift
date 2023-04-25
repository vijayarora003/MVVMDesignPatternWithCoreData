//
//  AssignmentViewController.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit
import CoreData

final class ListViewController: BaseViewController  {
    
    static var storyBoardId: String = ViewIdentifiers.listViewController
    static var storyBoardName: String = StoryBoard.main
    @IBOutlet private weak var loadingWarningLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var viewModel: EmployeeViewModel!
    var dataSource: FetchResultController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
    }
    
    private func setUPUI() {
        viewModel = EmployeeViewModel(delegate: self,
                                      coreDataManagerDelegate: CoreDataManager.shared,
                                      apiRequestDelegate: APIRequest.shared)
        viewModel.loadEmployee()
        tableView.registerCell(EmployeeTableViewCell.self)
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        performFetchResult(groupBy: .name)
    }
    
    func performFetchResult(groupBy: GroupBy) {
        dataSource = FetchResultController(groupBy: groupBy)
        dataSource?.dataSourceDelegate = self
        dataSource?.fetchPerform()
        tableView.reloadData()
    }
    
    @IBAction private func groupByButtonAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: StringConstants.GroupBy, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: StringConstants.name, style: .default) { [weak self] (a) in
            self?.performFetchResult(groupBy: .name)
        })
        
        alert.addAction(UIAlertAction(title:  StringConstants.team, style: .default) { [weak self] (a) in
            self?.performFetchResult(groupBy: .team)
        })
        
        alert.addAction(UIAlertAction(title: StringConstants.cancel, style: .cancel , handler: nil))
        alert.popoverPresentationController?.sourceView = sender.customView
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        viewModel.loadEmployee()
        sender.endRefreshing()
    }
}

extension ListViewController: EmployeeViewOutputDelegate {
    
    func show(message: String) {
        loadingWarningLabel.isHidden = false
        loadingWarningLabel.text = message
    }
}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = dataSource?.numberOfSections() ?? 0
        showHideLoading(isHidden: sections > 0)
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(with: EmployeeTableViewCell.self, indexPath: indexPath)
        cell.model = dataSource?.object(at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource?.titleForSection(section: section)
    }
    
    func showHideLoading(isHidden: Bool) {
        loadingWarningLabel.isHidden = isHidden
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 50
        return UITableView.automaticDimension
    }
}

extension ListViewController: FetchResultDelegate {
    func didChange(at indexPath: IndexPath?, action: FetchResultAction) {
        if action == .insert, let indexPath = indexPath {
            tableView.insertRows(at: [indexPath], with: .bottom)
        }
    }
    
    func controllerDidChangeContent() {
        tableView.reloadData()
    }
}
