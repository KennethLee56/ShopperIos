//
//  ShopperTableViewController.swift
//  Shopper
//
//  Created by Lee, Kenneth Van on 11/13/19.
//  Copyright © 2019 Lee, Kenneth Van. All rights reserved.
//

import UIKit
import CoreData

class ShopperTableViewController: UITableViewController {
    
    // create a reference to a context
    let context = (UIApplication.shared.delegate as!
        AppDelegate).persistentContainer.viewContext
    
    // create an array of ShoppingList entities
    var shoppingLists = [ShoppingList] ()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // fetch ShoppingLists from Core Data
    func loadShoppingLists() {
        
        // create an instance of a FetchRequest so that
        // ShoppingLists can be fetched from Core Data
        let request: NSFetchRequest<ShoppingList>  = ShoppingList.fetchRequest()
        
        do {
            // use context to execute a fetch request
            // to fetch ShoppingLists from Core Data
            // store the fetched ShoppingLists in our array
            shoppingLists = try context.fetch(request)
        } catch {
            print("Error fetching ShoppingLists from Core Data!")
        }
        
        // reload the fetched data in the Table View Controller
        tableView.reloadData()
    }
    
    // save ShoppingList entities into Core Data
    func saveShoppingLists () {
        do {
            // use context to save ShoppingLists into Core Data
            try context.save()
        } catch {
            print("Error saving ShoppingLists to Core Data!")
        }
        
        // reload the data in the Table View Controller
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // declare Text Fields variables for the input of the name. store. and data
        var nameTextField = UITextField()
        var storeTextField = UITextField()
        var dateTextField = UITextField()
        
        // create an Alert Controller
        let alert = UIAlertController(title: "Add Shopping List", message: "", preferredStyle: .alert)
        
        // define an action that will occur when the Add List button is pushed
        let action = UIAlertAction(title: "Add List", style: .default, handler: { (action) in
            
            // create an instance of a ShoppingList entity
            let newShoppingList = ShoppingList(context: self.context)
            
            //get name, store, and date input by user and store them in ShoppingList entity
            newShoppingList.name = nameTextField.text!
            newShoppingList.store = storeTextField.text!
            newShoppingList.date = dateTextField.text!
            
            // add ShoppingList entity into array
            self.shoppingLists.append(newShoppingList)
            
            // save ShoppingLists into Core Data
            self.saveShoppingLists()
        })
        
        // disable the action that will occure when the Add List button is pushed
        action.isEnabled = false
        
        // define an action that will occure when the Cancel is pushed
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (cancelAction) in
            
        })
        
        // add actions into Alert Controller
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // add the Text Fields into the Alert Controller
        alert.addTextField(configurationHandler: { (field) in
            nameTextField = field
            nameTextField.placeholder = "Enter Name"
            nameTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            storeTextField = field
            storeTextField.placeholder = "Enter Store"
            storeTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        alert.addTextField(configurationHandler: { (field) in
            dateTextField = field
            dateTextField.placeholder = "Enter Date"
            dateTextField.addTarget(self, action: #selector((self.alertTextFieldDidChange)), for: .editingChanged)
        })
        
        // display the Alert Controller
        present(alert, animated: true, completion: nil)
    }
    
    @objc func alertTextFieldDidChange (){
        
        // get a reference to the Alert Controller
        let alertController = self.presentedViewController as!
        UIAlertController
        
        // get a reference to the action that allows the user to add a ShoppingList
        let action = alertController.actions[0]
        
        //get references to the text in the Text Fields
        if let name = alertController.textFields![0].text, let
            store = alertController.textFields![1].text, let
            date = alertController.textFields![2].text {
            
            // trim whitespace from the text
            let trimmedName = name.trimmingCharacters(in: .whitespaces)
            let trimmedStore = store.trimmingCharacters(in: .whitespaces)
            let trimmedDate = date.trimmingCharacters(in: .whitespaces)
            
            // check if the trimmed text isn't empty and if it isn't enable the action that allows the user to add a ShoppingList
            if(!trimmedName.isEmpty && !trimmedStore.isEmpty && !trimmedDate.isEmpty){
                action.isEnabled = true;
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        // we will have as many rows as there are shopping lists
        // in the Shopping List entity in Core Data
        return shoppingLists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)

        // Configure the cell...
        let shoppingList = shoppingLists[indexPath.row]
        cell.textLabel?.text = shoppingList.name!
        cell.detailTextLabel?.text = shoppingList.store! + " " + shoppingList.date!

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
