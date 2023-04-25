//
//  FetchResultController.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//

import UIKit
import CoreData

protocol FetchResultDelegate: AnyObject {
    func didChange(at indexPath: IndexPath?, action: FetchResultAction)
    func controllerDidChangeContent()
}

enum FetchResultAction {
    case insert
    case delete
    case update
}

class FetchResultController: NSFetchedResultsController<NSFetchRequestResult> {
    
    weak var dataSourceDelegate: FetchResultDelegate?
    var blockOperations = [BlockOperation]()
    private var groupBy: GroupBy = .name
    
    init(groupBy: GroupBy) {
        super.init()
        self.groupBy = groupBy
    }
    
    lazy var fetchResultsController: NSFetchedResultsController<Records> = {
        let fetchRequest = NSFetchRequest<Records>(entityName: "Records")
        if groupBy == .name {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "fullName", ascending: true)]
        } else {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "team", ascending: true)]
        }
        fetchRequest.fetchBatchSize = 10
        let context = CoreDataManager.shared.mainContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "fullName", cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    func fetchPerform() {
        try? fetchResultsController.performFetch()
    }
    
    func numberOfSections() -> Int {
       return fetchResultsController.sections?.count ?? 0
    }
    
    func numberOfRows(section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> Records {
        return fetchResultsController.object(at: indexPath)
    }
    
    func titleForSection(section: Int) -> String {
        let title = fetchResultsController.sections?[section].name ?? ""
        if !title.isEmpty {
            let index = title.index(title.startIndex, offsetBy: 0)
            return String(title[index]).uppercased()
        }
        return title
    }
}

extension FetchResultController: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            blockOperations.append(BlockOperation(block: { [weak self] in
                guard let self = self else { return }
                self.dataSourceDelegate?.didChange(at: newIndexPath, action: .insert)
            }))
        } else if type == .delete {
            blockOperations.append(BlockOperation(block: { [weak self] in
                guard let self = self else { return }
                self.dataSourceDelegate?.didChange(at: newIndexPath, action: .delete)
            }))
        } else if type == .update {
            blockOperations.append(BlockOperation(block: { [weak self] in
                guard let self = self else { return }
                self.dataSourceDelegate?.didChange(at: newIndexPath, action: .update)
            }))
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        dataSourceDelegate?.controllerDidChangeContent()
    }
}

