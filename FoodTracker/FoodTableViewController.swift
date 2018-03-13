//
//  FoodTableViewController.swift
//  FoodTracker
//
//  Created by Internship on 2/27/18.
//  Copyright © 2018 Internship. All rights reserved.
//

import UIKit

class FoodTableViewController: UITableViewController {

    let foodCellIdentifier = "FoodTableViewCellIdentifier"
    var foods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let storedFoods = self.loadFoods() {
            self.foods = storedFoods
            print("Loaded stored things")
        } else {
            self.loadFoodDefaultData()
            print("Loaded default")
        }
        print("View did load")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("numberOfSections")
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("numberOfRowsInSection \(section)")
        
        return section == 0 ? (foods.count) : 2
    }
    
    func loadFoodDefaultData() {
        let foodOneImage = UIImage(named: "meal1")
        let foodTwoImage = UIImage(named: "meal2")
        let foodThreeImage = UIImage(named: "meal3")
        
        guard let foodOne = Food(name: "Chunchurria", image: foodOneImage, rating: 5) else {
            fatalError("Esa tal chunchurria no existe")
        }
        guard let foodTwo = Food(name: "Guacamole con chile", image: foodTwoImage, rating: 2) else {
            fatalError("Esa tal opinión de Diego no existe")
        }
        guard let foodThree = Food(name: "🍆", image: foodThreeImage, rating: 4) else {
            fatalError("Dieguiño's favourite")
        }
        foods += [foodOne, foodTwo, foodThree]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellForRowAt \(indexPath)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: foodCellIdentifier, for: indexPath) as? FoodTableViewCell else {
            fatalError("Esta pinche celda no compila :c")
        }
        
        cell.foodNameLabel.text = foods[indexPath.row].name
        cell.foodImage.image = foods[indexPath.row].image
        cell.ratingControl.rating = foods[indexPath.row].rating
//        cell.backgroundColor = .red
        // Configure the cell...

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        print("canEditRowAt \(indexPath)")
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("editingStyle \(indexPath)")
        if editingStyle == .delete {
            // Delete the row from the data source
            foods.remove(at: indexPath.row)
            saveFoods()
            tableView.deleteRows(at: [indexPath], with: .right)
//            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        print("moveRowAt from \(fromIndexPath) to \(to)")
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        print("targetIndexPathForMoveFromRowAt from \(sourceIndexPath) to \(proposedDestinationIndexPath)")
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        saveFoods()
        return proposedDestinationIndexPath
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("titleForHeaderInSection  \(section)")
        return "fud jeder \(section)"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        print("titleForFooterInSection  \(section)")
        return "fud futer \(section)"
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        print("canMoveRowAt  \(indexPath)")
        return true
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        print("sectionIndexTitles ")
        return ["0", "1","2","3","4","5","6","7","8","9"]
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        print("sectionForSectionIndexTitle title \(title) index \(index)")
        return index 
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("prepare")
        switch segue.identifier ?? "" {
        case "AddFood", "ShowCollection":
            break
        case "ShowFoodDetail":
            guard let destination = segue.destination as? FoodDetailViewController else {
                fatalError("Destination not found.")
            }

            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("You are a wizard, this index doesn't even exits.")
            }
            
            destination.food = foods[indexPath.row]
        default:
            fatalError("What the hell are you doing.")
        }        
    }
    
    @IBAction func unwidFoodFromSegue(segue: UIStoryboardSegue) {
        print("unwidFoodFromSegue")
        if let sourceViewController = segue.source as? FoodDetailViewController, let food = sourceViewController.food {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                foods[indexPath.row] = food
                tableView.reloadRows(at: [indexPath], with: .middle)
            } else {
                let indexPath = IndexPath(row: foods.count, section: 0)
                foods.append(food)
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            saveFoods()
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        print("shouldShowMenuForRowAt")
        return false
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "En un lugar de la mancha cuyo nombre no quiero recordar"
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        print("canFocusRowAt")
        return false
    }
    
    func saveFoods(){
        let successFoodsSave = NSKeyedArchiver.archiveRootObject(foods, toFile: Food.ArchiveURL.path)
        if successFoodsSave {
            print("The food is on the table")
        } else {
            print("Oh god, no more food on the table")
        }
    }
    
    func loadFoods() -> [Food]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Food.ArchiveURL.path) as? [Food]
    }
}
