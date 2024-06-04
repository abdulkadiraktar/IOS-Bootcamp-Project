//
//  ViewController.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import UIKit
import RxSwift
import Kingfisher

class Homepage: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var foodCollection: UICollectionView!
    
    var viewModel = HompageViewModel()
    
    var foodList = [Food]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        foodCollection.delegate = self
        foodCollection.dataSource = self
        
        
        let design :UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let width = self.foodCollection.frame.size.width
        
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cellWidth = (width-30)/2
        
        design.itemSize = CGSize(width: cellWidth, height: cellWidth*1.3)
        
        design.minimumInteritemSpacing = 10
        design.minimumLineSpacing = 10
        
        foodCollection.collectionViewLayout = design
        
        _ = viewModel.foodList.subscribe(onNext: { list in
            
            self.foodList = list
            DispatchQueue.main.async {
                self.foodCollection.reloadData()
            }
          
            
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFood(searchText: "" )
    }
}

extension Homepage : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getFood(searchText: searchText)
    }
}
extension Homepage: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCell
        
        let food = foodList[indexPath.row]
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(food.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.imageViewFood.kf.setImage(with: url)
            }
        }
        cell.labelFood.text = "\(food.yemek_adi!)"
        cell.labelPrice.text = "₺\(food.yemek_fiyat!)"
        
        
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = foodList[indexPath.row]
        performSegue(withIdentifier: "toDetail", sender: food)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let food = sender as? Food {
                let vc = segue.destination as! DetailPage
                vc.food = food
            }
        }
    }
}
