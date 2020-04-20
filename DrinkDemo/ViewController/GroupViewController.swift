//
//  GroupViewController.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/18.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit
import Alamofire

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var groupTableView: UITableView!
    var groups = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        navigationItem.title = "群組管理"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        groupTableView.dataSource = self
        groupTableView.delegate = self
        getGroupList()
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
                guard let _groups = groups else {return}
                self.groups = _groups as! [Group]
//                debugPrint(self.groups)
                self.groupTableView.reloadData()
            }
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        
        cell.groupNameLabel.text = groups[indexPath.row].name
        cell.groupInfo = groups[indexPath.row]
        cell.indexPath = indexPath
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let controller = segue.destination as? GroupFormTableViewController {
            if segue.identifier == "EditGroup"{
                controller.actionType = "edit"
                if let row = groupTableView.indexPathForSelectedRow?.row{
                    controller.group = groups[row]
                }
            }else{
                controller.actionType = "add"
            }
        }
    }

}
