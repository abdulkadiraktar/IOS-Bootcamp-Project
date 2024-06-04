//
//  FoodCell.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import UIKit



class FoodCell: UICollectionViewCell {
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelFood: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    
   
    var indexPath:IndexPath?
}
