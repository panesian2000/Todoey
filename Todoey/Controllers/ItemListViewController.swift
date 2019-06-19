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
    var selectedCategory: Category? {
        didSet {
            navigationItem.title = selectedCategory!.title!
            LoadingData()
        }
    }
    var itemArray: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell", for: indexPath)
        let item: Item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.completed ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        let item: Item = itemArray[indexPath.row]
        
        item.completed = !item.completed
        cell.accessoryType = item.completed ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        
        SavingData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Barbutton methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemTextField: UITextField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let alertAddAction: UIAlertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            if let title = itemTextField.text {
                if !title.isEmpty {
                    let item: Item = Item(context: self.context)
                    item.title = title
                    item.completed = false
                    item.categoryParent = self.selectedCategory!
                    
                    self.itemArray.append(item)
                    self.SavingData()
                }
            }
        }
        let alertCancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
        }
        
        alert.addTextField {
            (textField) in
            textField.placeholder = "Create a new item"
            itemTextField = textField
        }
        alert.addAction(alertAddAction)
        alert.addAction(alertCancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Manipulate data methods
    func SavingData() {
        do {
            try context.save()
            tableView.reloadData()
        }
        catch {
            print("Error saving item into core data, \(error)")
        }
    }
    
    func LoadingData(filter: NSPredicate? = nil) {
        do {
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            var predicateList: [NSPredicate] = []

            predicateList.append(NSPredicate(format: "categoryParent.title MATCHES %@", selectedCategory!.title!))

            if filter != nil {
                predicateList.append(filter!)
            }
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicateList)
            request.sortDescriptors = [sortDescriptor]
            
            itemArray = try context.fetch(request)
            tableView.reloadData()
        }
        catch {
            print("Error loading item from core data, \(error)")
        }
    }

}

extension ItemListViewController: UISearchBarDelegate {
    
    //MARK: Searchbar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let filter: NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        LoadingData(filter: filter)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            LoadingData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
