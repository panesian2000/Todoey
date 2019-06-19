//
//  ItemListViewController.swift
//  Todoey
//
//  Created by Kenny Loh on 17/6/19.
//  Copyright © 2019 ProApp Concept Pte Ltd. All rights reserved.
//

import UIKit
import CoreData

class ItemListViewController: UITableViewController {

    //MARK: Local global variables
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category?
    var itemArray: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tableview datasource methods
    
    //MARK: Tableview delegate methods
    
    //MARK: Barbutton methods
    
    //MARK: Manipulate data methods

}

extension ItemListViewController: UISearchBarDelegate {
    
    //MARK: Searchbar methods
    
}
