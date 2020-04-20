//
//  HomeViewController.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/16.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController,SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        if let items = tabBarController?.tabBar.items{
//            let item = items[1]
//            item.badgeValue = "99"
//        }
//        let navController = self.tabBarController?.viewControllers?[2] as? UINavigationController
//        let controller = navController?.viewControllers[0] as? GroupOrderViewController
//        self.present(controller, animated: true, completion: nil)
        
//        self.navigationController?.pushViewController(controller!,animated: true)
//        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "GroupOrderView") {
//            controller.modalPresentationStyle = .fullScreen
//        }
    }
    
    @IBAction func openSafari(_ sender: Any) {
        if let url = URL(string: "http://www.kebuke.com/"){ //http://www.kebuke.com/
            let safari = SFSafariViewController(url: url)
            safari.delegate = self
            present(safari, animated: true, completion: nil)
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
