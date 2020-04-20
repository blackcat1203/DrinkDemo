//
//  GroupFormTableViewController.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/19.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit

class GroupFormTableViewController: UITableViewController {

    @IBOutlet weak var groupNameField: UITextField!
    var actionType:String?
    var group:Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let group = self.group , self.actionType == "edit"{
            groupNameField.text = group.name
        }
        
    }

    @IBAction func doneAction(_ sender: Any) {
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        if groupNameField.text?.isEmpty == false{
            if let actionType = self.actionType{
                switch actionType {
                case "edit":
                    let groupName = groupNameField.text ?? ""
                    let newGroup = Group(groupId: group?.groupId ?? "", name: groupName, status: "1")
                    let createGroup = CreateGroup(data: [newGroup])
                    let encoder: JSONEncoder = JSONEncoder()
                    let createGroupEncode = try? encoder.encode(createGroup)
                    let dict = try? JSONSerialization.jsonObject(with: createGroupEncode!, options: []) as? [String: Any]
                    let service = Service()
                    service.cudAction(endPoint: "/groupId/\(group!.groupId)?sheet=group", params: dict!, method: .put)
                    service.completionHandlerForObject {(data, status, message) in
                        if status {
                            child.willMove(toParent: nil)
                            child.view.removeFromSuperview()
                            child.removeFromParent()
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            debugPrint(message)
                        }
                    }
                default:
                    let service = Service()
                    service.getAllGroupCount(endPoint: "/count?sheet=group")
                    service.completionHandlerForObject{(data, status, message) in
                        if status {
                            guard let _data = data else {return}
                            let getCount = _data as! GetCount
                            let count = getCount.rows! + 1
                            let groupName = self.groupNameField.text ?? ""
                            let newGroup = Group(groupId: "\(count)", name: groupName, status: "1")
                            let createGroup = CreateGroup(data: [newGroup])
                            let encoder: JSONEncoder = JSONEncoder()
                            let createGroupEncode = try? encoder.encode(createGroup)
                            let dict = try? JSONSerialization.jsonObject(with: createGroupEncode!, options: []) as? [String: Any]
                            service.cudAction(endPoint: "?sheet=group", params: dict!, method: .post)
                            service.completionHandlerForObject{(data, status, message) in
                                child.willMove(toParent: nil)
                                child.view.removeFromSuperview()
                                child.removeFromParent()
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else{
                            debugPrint(message)
                        }
                    }
                }
            }
        } else {
            let alertController = Tool.errorAlert(title: "error", message: "Group Name is Empty")
            present(alertController, animated: true, completion: nil)
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
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
