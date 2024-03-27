//
//  Cate_CreatePost_TableViewCell.swift
//  RaoVat2020
//
//  Created by Khoa Pham on 8/30/20.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit

class Cate_CreatePost_TableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_Cate: UIImageView!
    @IBOutlet weak var lbl_CateName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
