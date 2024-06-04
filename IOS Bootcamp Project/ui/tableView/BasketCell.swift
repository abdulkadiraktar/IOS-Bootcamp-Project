//
//  BasketCell.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import UIKit
import RxSwift
class BasketCell: UITableViewCell {

    @IBOutlet weak var labelFoodPrice: UILabel!
    @IBOutlet weak var labelPiece: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelFood: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    
    var viewModel = BasketDetailViewModel()
    
    var frepo = FoodRepo()
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
