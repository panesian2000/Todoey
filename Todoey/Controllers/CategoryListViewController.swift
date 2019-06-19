//
//  ViewController.swift
//  Todoey
//
//  Created by Kenny Loh on 17/6/19.
//  Copyright © 2019 ProApp Concept Pte Ltd. All rights reserved.
//

import UIKit
import CoreData

class CategoryListViewController: UITableViewController {
    
    //MARK: Local global variables
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadingData()
    }

    //MARK: Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CategoryListCell", for: indexPath)
        let category: Category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.title
        
        return cell
    }
    
    //MARK: Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ItemListViewController
        let indexPath = tableView.indexPathForSelectedRow!
        
        destVC.selectedCategory = categoryArray[indexPath.row]
    }
    
    //MARK: Barbutton methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField: UITextField = UITextField()
        let alert: UIAlertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAddAction: UIAlertAction = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            if let title = categoryTextField.text {
                if !title.isEmpty {
                    let category: Category = Category(context: self.context)
                    category.title = title
                    
                    self.categoryArray.append(category)
                    self.SavingData()
                }
            }
        }
        let alertCancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create a new category"
            categoryTextField = textField
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
            print("Error saving category into core data, \(error)")
        }
    }

    func LoadingData() {
        do {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error loading category from core data, \(error)")
        }
    }

}
