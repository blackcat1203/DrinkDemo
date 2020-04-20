//
//  GroupOrderViewController.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/20.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit

class GroupOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var groupOrderTableView: UITableView!
    var groups:[Group]?
    var orders:[Order]?
    var groupOrderList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupOrderTableView.dataSource = self
        groupOrderTableView.delegate = self
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
                self.groups = groups as? [Group]
                
                service.getOrderList(endPoint: "?sheet=order&sort_by=groupId&sort_order=ASC")
                service.completionHandler {(data, status, message) in
                    if status{
                        self.orders = data as? [Order]
                        self.groupOrderList = [String]()
                        let dataList = Dictionary(grouping: self.orders! ){ $0.groupId! }
                        dataList.forEach({ (key,value) in
                            self.groupOrderList.append(key)
                        })
                        self.groupOrderList.sort()
                        self.groupOrderTableView.reloadData()
                    }else{
//                        debugPrint(message)
                    }
                }
            }
            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupOrderList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupOrderCell", for: indexPath) as! GroupOrderTableViewCell

        let index = groups?.firstIndex(where: {$0.groupId == groupOrderList[indexPath.row] }) ?? 0
        if let groups = groups{
            cell.groupNameLabel.text = "\(groups[index].name) 的訂單"
            cell.groupId = groups[index].groupId
        }
        
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let controller = segue.destination as? OrderViewController {
            if let row = groupOrderTableView.indexPathForSelectedRow?.row{
                controller.groupId = groupOrderList[row]
                let index = groups?.firstIndex(where: {$0.groupId == groupOrderList[row] }) ?? 0
                controller.groupName = groups?[index].name
            }
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

}
