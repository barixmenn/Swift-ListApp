//
//  ViewController.swift
//  ListApp
//
//  Created by macbook on 5.07.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //Data List
    var data = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        fecth()
        
        
    }
    
    //MARK: -Delete Button
    @IBAction func deleteButtonAction(_ sender: UIBarButtonItem) {
        
        data.removeAll()
        tableView.reloadData()
    }
    //MARK: -Add button
    @IBAction func plusButtonAction(_ sender: UIBarButtonItem) {
        self.presentAddAlert(title: "Ekle", message: "")
    }
    
    //MARK: -Add Alert
    func presentAddAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ekle", style: .default) { UIAlertAction in
            
            let text = alert.textFields?.first?.text
            if  text != "" {
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                
                let listItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                
                listItem.setValue(text, forKey: "title")
                try? managedObjectContext?.save()
                self.fecth()
            } else {
                self.presentWarningAlert(title: "Uyarı!", message: "Boş veri eklenemez!")
            }
            
        }
        
        let cancelButton = UIAlertAction(title: "Vazgeç", style: .cancel)
        alert.addTextField()
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    //MARK: -Warning Alert
    func presentWarningAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Tamam", style: .default)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    //MARK: -GET DATA
    func fecth () {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        
        let fecthRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        data = try! managedObjectContext!.fetch(fecthRequest)
        tableView.reloadData()
    }
}

//MARK: -TableView Delegate and DataSource
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    //ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    //CELL
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "title") as? String
        
        return cell
    }
    
    //MARK: - Delete Button
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Delete Button
        let deleteAction = UIContextualAction(style: .normal, title: "Sil") { _, _, _ in
            
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.data[indexPath.row])
            try? managedObjectContext?.save()
            self.fecth()
            self.tableView.reloadData()
        }
        deleteAction.backgroundColor = .systemRed
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
        
    }
}

