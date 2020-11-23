//
//  TBTableViewDiffableDataSource.swift
//  The Bookshelf
//
//  Created by Jacques Benzakein on 11/22/20.
//  Copyright © 2020 Q Technologies. All rights reserved.
//

import UIKit

class TBTableViewDiffableDataSource: UITableViewDiffableDataSource<MainVC.Section, Book> {
    
    var deleteBookDelegate: DeleteBookDelegate!
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        guard editingStyle == .delete else { return }
        
        let cell = tableView.cellForRow(at: indexPath) as! TBBookCell
        let bookToDelete = cell.book!
        deleteBookDelegate.didRequestToDelete(book: bookToDelete)
        
    }
}
