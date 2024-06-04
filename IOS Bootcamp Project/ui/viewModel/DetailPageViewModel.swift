//
//  DetailPageViewModel.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import Foundation
import RxSwift

class DetailPageViewModel {
    var frepo = FoodRepo()
    
    var basketList = BehaviorSubject<[BasketFood]>(value: [BasketFood]())
    var foodAdet = BehaviorSubject<Int>(value: 1)
    var foodTotalPrice = BehaviorSubject<Int>(value: 0)
    
    init(){
        foodAdet = frepo.foodAdet
        foodTotalPrice = frepo.foodTotalPrice
       
        basketList = frepo.basketList
    }
    
    func plus() {
        frepo.plus()
    }
    func minus(){
        frepo.minus()
    }
    func addToBasket(yemek_adi:String,yemek_resim_adi:String,yemek_fiyat:Int,yemek_siparis_adet:Int,kullanici_adi:String) {
        frepo.addToBasket(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
    }
    
}
