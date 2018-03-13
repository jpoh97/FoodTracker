//
//  ViewController.swift
//  FoodTracker
//
//  Created by Internship on 2/21/18.
//  Copyright © 2018 Internship. All rights reserved.
//

import UIKit
import os.log

class FoodDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var foodNameTextField: UITextField!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodRatingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var food: Food?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodNameTextField.delegate = self
        
        if let editFood = food {
            foodNameTextField.text = editFood.name
            foodNameLabel.text = editFood.name
            foodImage.image = editFood.image
            foodRatingControl.rating = editFood.rating
        }
        
        updateSaveButtonEnableState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        foodNameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func updateSaveButtonEnableState() {
        saveButton.isEnabled = !foodNameTextField.text!.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        foodNameLabel.text = foodNameTextField.text
        updateSaveButtonEnableState()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        foodImage.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        foodNameTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancelDetailFood(_ sender: UIBarButtonItem) {
        let isPresentingInAddFoodMode = presentingViewController is UINavigationController
        if isPresentingInAddFoodMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("Has llegado de una manera imposible, pero no te dejaré ir 🙂")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("Has llegado aqui de una manera imposible", log: OSLog.default, type: .debug)
            return;
        }
        
        let name = foodNameLabel.text ?? ""
        let photo = foodImage.image
        let rating = foodRatingControl.rating
        
        food = Food(name: name, image: photo, rating: rating)
    }    
}

