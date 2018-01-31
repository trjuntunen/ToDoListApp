//
//  AddNewTaskViewController.swift
//  Twoodle
//
//  Created by Teddy Juntunen on 1/30/18.
//  Copyright © 2018 Teddy Juntunen. All rights reserved.
//

import UIKit
import CoreData

class AddNewTaskViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskField: UITextField!
    
    @IBOutlet weak var detailsField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorners()
        addLeftPaddingTo(textField: taskField)
        addLeftPaddingTo(textField: detailsField)
        taskField.becomeFirstResponder()
        taskField.delegate = self
        detailsField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addLeftPaddingTo(textField: UITextField) {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 0.0))
        textField.leftView = leftView
        textField.leftViewMode = .always
    }
    
    private func roundCorners() {
        taskField.layer.cornerRadius = 5
        detailsField.layer.cornerRadius = 5
        submitButton.layer.cornerRadius = 5
    }
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func saveTaskToCoreData() {
        // setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let newTask = NSManagedObject(entity: entity!, insertInto: context)
        
        // save to core data
        newTask.setValue(taskField.text, forKey: "main")
        newTask.setValue(detailsField.text, forKey: "detail")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == taskField && textField.text != "") {
            detailsField.becomeFirstResponder()
        }
        if(textField == detailsField) {
            addTask(self)
        }
        return true
    }
    
    @IBAction func addTask(_ sender: Any) {
        if(taskField.text == "") {
            return
        }
        saveTaskToCoreData()
        dismiss(animated: true, completion: nil)
    }
    
    // tap anywhere on the screen to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Sets the text of the status bar to white font
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
