//
//  FoodCollectionViewController.swift
//  FoodTracker
//
//  Created by Internship on 3/2/18.
//  Copyright © 2018 Internship. All rights reserved.
//

import UIKit


class FoodCollectionViewController : UICollectionViewController {
    
    var foods = [Food]()
    let reuseIdentifier = "FoodCollectionCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadFoodDefaultData()
        
        if let layout = collectionView?.collectionViewLayout as? FoodCollectionViewLayout {
            layout.delegate = self
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(FoodCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return foods.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(foods)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FoodCollectionViewCell else {
            fatalError("\(indexPath.row) \(reuseIdentifier)")
        }
        cell.foodLabelView.text = foods[indexPath.row].name
        cell.foodImageView.image = foods[indexPath.row].image
        print(cell.foodLabelView.text!)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare")
        
        switch segue.identifier ?? "" {
        case "AddFood", "ShowTable":
            print("ALV")
        case "ShowFoodDetail":
            guard let destination = segue.destination as? FoodDetailViewController else {
                fatalError("Destination not found exception")
            }
            
            guard let indexPath = collectionView?.indexPathsForSelectedItems else {
                fatalError("You are a wizard men")
            }
            
            destination.food = foods[indexPath[0].item]
        default:
            fatalError("Siwey Error :c")
        }
    }
    
    @IBAction func unwidFoodFromSegue(segue: UIStoryboardSegue) {
        print("unwidFoodFromSegueToCollection")
        if let sourceViewController = segue.source as? FoodDetailViewController, let food = sourceViewController.food {
            if let indexPathArray = collectionView?.indexPathsForSelectedItems, !indexPathArray.isEmpty {
                foods[indexPathArray[0].item] = food
                collectionView?.reloadItems(at: indexPathArray)
                
            } else {
                let indexPath = IndexPath(item: foods.count, section: 0)
                foods.append(food)
                collectionView?.prepareForInterfaceBuilder()
                collectionView?.insertItems(at: [indexPath])
            }
        }
    }
    
}

extension FoodCollectionViewController : FoodLayoutDelegate {
    
    func collectionView(_ collectionView:UICollectionView, sizeForImageAtIndexPath indexPath:IndexPath) -> (height: CGFloat, width: CGFloat) {
        let height = foods[indexPath.item].image?.size.height
        let width = foods[indexPath.item].image?.size.width
        return (height!, width!)
    }
    
}
