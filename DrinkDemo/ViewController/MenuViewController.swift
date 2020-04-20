//
//  MenuViewController.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/17.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
            
    @IBOutlet weak var menuTableView: UITableView!
    var drinkList = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.delegate = self
        menuTableView.dataSource = self
        // Do any additional setup after loading the view.
        let url = Bundle.main.url(forResource: "DrinkList", withExtension: "plist")!
        if let data = try? Data(contentsOf: url), let drinks = try? PropertyListDecoder().decode([Drink].self, from: data) {
            drinkList = drinks
            menuTableView.reloadData()
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
        
        cell.nameLabel.text = drinkList[indexPath.row].drinkName
        cell.descriptionLabel.text = drinkList[indexPath.row].description
        cell.priceLabel.text = String(drinkList[indexPath.row].middlePrice)
        cell.imageView?.image = UIImage(named: drinkList[indexPath.row].image)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let controller = segue.destination as? OrderDrinkTableViewController {
            if let row = menuTableView.indexPathForSelectedRow?.row{
                controller.actionType = "add"
                controller.drink = drinkList[row]
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
