//
//  OrderDrinkTableViewController.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/19.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit

class OrderDrinkTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var sizeSegmented: UISegmentedControl!
    @IBOutlet weak var sugarSegmented: UISegmentedControl!
    @IBOutlet weak var iceSegmented: UISegmentedControl!
    @IBOutlet weak var addSegmented: UISegmentedControl!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var middleOnlyLabel: UILabel!
    var actionType:String?
    let groupPicker = UIPickerView()
    var groups:[Group]?
    var selectGroup:Group?
    var drink:Drink?
//    var order:Order?
    var priceTotal:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupPicker.dataSource = self
        groupPicker.delegate = self
        getGroupList()
        
        if let drink = self.drink{
            drinkNameLabel.text = drink.drinkName
            if drink.bigPrice == 0{
                sizeSegmented.isHidden = true
                middleOnlyLabel.isHidden = false
            }
            drinkPriceTotal()
        }
        
        groupTextField.inputView = groupPicker
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getGroupList(){
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        let service = Service()
        service.getGroupList(endPoint: "/search?sheet=group&status=1")
        service.completionHandler {(groups, status, message) in
            if status {
//                guard let _groups = groups else {return}
                self.groups = groups as? [Group]
                //                debugPrint(self.groups)
                if let groups = self.groups, self.groups?.count != 0 {
                    self.groupTextField.text = groups[0].name
                    self.selectGroup = groups[0]
                    self.groupPicker.selectRow(0, inComponent: 0, animated: true)
                }
                self.groupPicker.reloadAllComponents()
            }
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    func drinkPriceTotal(){
        if sizeSegmented.selectedSegmentIndex == 1 {
            priceTotal = drink?.bigPrice ?? 0
        }else{
            priceTotal = drink!.middlePrice
        }
        
        if addSegmented.selectedSegmentIndex == 1{
            priceTotal += 10
        }
        priceLabel.text = String(priceTotal)
    }
    
    @IBAction func sizeChange(_ sender: UISegmentedControl) {
        drinkPriceTotal()
    }
    
    @IBAction func addChange(_ sender: UISegmentedControl) {
        drinkPriceTotal()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        if nameField.text?.isEmpty == false || groupTextField.text?.isEmpty == false {
            if let actionType = self.actionType{
                switch actionType {
                case "edit":
                    break
                default:
                    let order = Order(orderId: UUID().uuidString,
                                      groupId: String(selectGroup?.groupId ?? ""),
                                      name: self.nameField.text ?? "",
                                      drink: self.drinkNameLabel.text ?? "",
                                      size: CommomData.size[sizeSegmented.selectedSegmentIndex],
                                      sugar: CommomData.sugar[sugarSegmented.selectedSegmentIndex],
                                      ice: CommomData.ice[iceSegmented.selectedSegmentIndex],
                                      add: CommomData.add[addSegmented.selectedSegmentIndex],
                                      price: String(priceTotal) )
                    let createOrder = CreateOrder(data: [order])
                    let encoder: JSONEncoder = JSONEncoder()
                    let createEncode = try? encoder.encode(createOrder)
                    let dict = try? JSONSerialization.jsonObject(with: createEncode!, options: []) as? [String: Any]
                    let service = Service()
                    service.cudAction(endPoint: "?sheet=order", params: dict!, method: .post)
                    service.completionHandlerForObject{(data, status, message) in
                        child.willMove(toParent: nil)
                        child.view.removeFromSuperview()
                        child.removeFromParent()
                        let tabController = self.tabBarController
                        self.navigationController?.popViewController(animated: false )
                        tabController?.selectedIndex = 3
                    }
                }
            }
        } else {
            let alertController = Tool.errorAlert(title: "error", message: "input is Empty")
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groups?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectGroup = groups![row]
        groupTextField.text = selectGroup?.name
//        debugPrint(selectGroup)
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
