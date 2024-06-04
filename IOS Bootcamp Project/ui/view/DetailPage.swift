//
//  DetailPage.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import UIKit
import Kingfisher
import RxSwift

class DetailPage: UIViewController {
    
    @IBOutlet weak var labelAdet: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelFood: UILabel!
    @IBOutlet weak var imageViewFood: UIImageView!
    
    @IBOutlet weak var totalPrice: UILabel!
    var viewModel = DetailPageViewModel()

    var food:Food?
    var basketList = [BasketFood]()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _ = viewModel.basketList.subscribe(onNext: {  list in
            self.basketList = list
 
        })
        
        _ = viewModel.frepo.foodAdet.subscribe(onNext: { adet in
            self.labelAdet.text = String(adet)
        })
        _ = viewModel.frepo.foodTotalPrice.subscribe(onNext: { foodPrice in
             self.totalPrice.text = String(foodPrice)
        })
        if let f = food {
            labelFood.text = f.yemek_adi
            labelPrice.text = f.yemek_fiyat!
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(f.yemek_resim_adi!)") {
                DispatchQueue.main.async {
                    self.imageViewFood.kf.setImage(with: url)
                }
            }
            
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        totalPrice.text = food?.yemek_fiyat
    }
    
    @IBAction func plus(_ sender: Any) {
        viewModel.plus()
        viewModel.frepo.calculate(price: Int((food?.yemek_fiyat)!)!)
    }
    
    @IBAction func minus(_ sender: Any) {
        viewModel.minus()
        viewModel.frepo.calculate(price: Int((food?.yemek_fiyat)!)!)
    }
    
    @IBAction func AddBasketButton(_ sender: Any) {
        if let f = food {
            if let yemek_adi = labelFood.text, let yemek_resim_adi = f.yemek_resim_adi, let yemek_fiyat = labelPrice.text, let yemek_siparis_adet = labelAdet.text {
                viewModel.addToBasket(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: Int(yemek_fiyat)!, yemek_siparis_adet: Int(yemek_siparis_adet)!, kullanici_adi: "abdulkadir_aktar")

            }
                    }
    }
    
    

    
}
