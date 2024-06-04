//
//  BasketDetailViewModel.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import Foundation
import RxSwift
import Lottie
class BasketDetailViewModel {
    
    var frepo = FoodRepo()
    
    var basketList = BehaviorSubject<[BasketFood]>(value: [BasketFood]())
    var foodAdet = BehaviorSubject<Int>(value: 1)
    var foodTotalPrice = BehaviorSubject<Int>(value: 0)
    
    init() {
        basketList = frepo.basketList
        foodAdet = frepo.foodAdet
        foodTotalPrice = frepo.foodTotalPrice
        
    }
    
    func delete (sepet_yemek_id:Int,kullanici_adi:String) {
        frepo.delete(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
       
    }
    
    func getBasket (kullanici_adi: String) {
        frepo.getBasket(kullanici_adi: kullanici_adi )
    }
}
