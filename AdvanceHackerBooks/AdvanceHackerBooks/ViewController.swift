//
//  ViewController.swift
//  AdvanceHackerBooks
//
//  Created by jro on 06/09/16.
//  Copyright © 2016 jro. All rights reserved.
//

import UIKit

//Add below "import UIKit"
import CoreData


class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView:UITableView!
    
    @IBAction func addName(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        // SIN CORE DATA
        /*
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.names.append(textField!.text!)
                                        self.tableView.reloadData()
        })
         */
        
        // CON CORE DATA
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveName(name: textField!.text!)
                                        self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
                              animated: true,
                              completion: nil)
    }
    
    //Insert below the tableView IBOutlet
    //var names = [String]()
    
    //Change “names” to “people” and [String] to [NSManagedObject]
    var people = [NSManagedObject]()
    
    // SIN CORE DATA
    /*
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        super.viewDidLoad()
        title = "\"The List\""
         tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
     */
    
    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //2
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        //let fetchRequest : NSFetchRequest<NSFetchRequestResult> = Person.fetchRequest()
        //let fetchRequest = NSFetchRequest(entityName: "Person")
        
        //3
        do {
            let results = try managedContext.fetch(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    /* SIN CORE DATA
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell!.textLabel!.text = names[indexPath.row]
        
        return cell!
    }*/
    
    // CON CORE DATA
    //Replace both UITableViewDataSource methods
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let person = people[indexPath.row]
        
        let aux = person.value(forKey: "name") as? String
        
        cell!.textLabel!.text = aux
        
        return cell!
    }
    
    func saveName(name: String) {
        //1
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let managedContext = appDelegate.managedObjectContext
        
        
        //var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        //var context:NSManagedObjectContext = appDel.managedObjectContext
        
        let appDelegate:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let managedContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        //2
        let entity =  NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
        
        let person = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        //3
        person.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    

}

