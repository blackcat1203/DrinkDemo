//
//  OrderViewController.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/20.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var orderTableView: UITableView!
    var drinkList = [Drink]()
    var orders:[Order]?
    var groupId:String?
    var groupName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let groupName = groupName {
            navigationItem.title = "\(groupName) 的訂單"
        }
        
        let url = Bundle.main.url(forResource: "DrinkList", withExtension: "plist")!
        if let data = try? Data(contentsOf: url), let drinks = try? PropertyListDecoder().decode([Drink].self, from: data) {
            drinkList = drinks
        }
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
        getOrderList()
    }
    
    func getOrderList(){
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        let service = Service()
        if let groupId = groupId {
            service.getOrderList(endPoint: "/search?sheet=order&groupId=\(groupId)")
            service.completionHandler {(data, status, message) in
                if status{
                    self.orders = data as? [Order]
                    self.orderTableView.reloadData()
                }else{
                    debugPrint(message)
                }
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderTableViewCell
        
        if let orders = orders{
            let index = drinkList.firstIndex(where: {$0.drinkName == orders[indexPath.row].name }) ?? 0
            cell.imageView?.image = UIImage(named: drinkList[index].image)
            cell.nameLabel.text = orders[indexPath.row].name
            cell.drinkLabel.text = orders[indexPath.row].drink
            cell.sizeLabel.text = orders[indexPath.row].size
            cell.sugarLabel.text = "糖度:\(orders[indexPath.row].sugar)"
            cell.iceLabel.text = "冰度:\(orders[indexPath.row].ice)"
            cell.addLabel.text = orders[indexPath.row].add
            cell.priceLabel.text = "$\(orders[indexPath.row].price)"
        }
        
        return cell
    }
}
