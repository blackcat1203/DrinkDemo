//
//  GroupTableViewCell.swift
//  DrinkDemo
//
//  Created by Leon on 2020/4/18.
//  Copyright © 2020 Leon. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    var groupId:String?
    var groupInfo:Group?
    var indexPath:IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
