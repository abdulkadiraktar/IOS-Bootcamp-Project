//
//  FoodRepo.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import Foundation
import RxSwift
import Alamofire

class FoodRepo {
    var foodList = BehaviorSubject<[Food]>(value: [Food]())
    var basketList = BehaviorSubject<[BasketFood]>(value: [BasketFood]())
    var foodAdet = BehaviorSubject<Int>(value: 1)
    var foodTotalPrice = BehaviorSubject<Int>(value: 0)
    
    
    func plus (){
        let currentValue = try! foodAdet.value()
        foodAdet.onNext(currentValue + 1)
    }
    func minus (){
        let currentValue = try! foodAdet.value()
        if currentValue > 1 {
            foodAdet.onNext(currentValue - 1)
        }
    }
    
    func calculate(price : Int) {
        let adet = try! foodAdet.value()
        let TotalPrice = Int(adet) * price
        foodTotalPrice.onNext(TotalPrice)
    }
    
    
    
    
    
    
    
    func addToBasket(yemek_adi:String,yemek_resim_adi:String,yemek_fiyat:Int,yemek_siparis_adet:Int,kullanici_adi:String) {
      
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php")!
        let params:Parameters = ["yemek_adi":yemek_adi,"yemek_resim_adi":yemek_resim_adi,"yemek_fiyat":yemek_fiyat,"yemek_siparis_adet":yemek_siparis_adet,"kullanici_adi":kullanici_adi]
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Başarı : \(response.success!)")
                    print("Mesaj : \(response.message!)")
                    
                }catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func delete (sepet_yemek_id:Int,kullanici_adi:String) {
       
        let url = URL(string: "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php")!
        let params:Parameters = ["sepet_yemek_id":sepet_yemek_id,"kullanici_adi":kullanici_adi]
        AF.request(url,method: .post,parameters: params).response { response in
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(CRUDResponse.self, from: data)
                    print("Başarı : \(response.success!)")
                    print("Mesaj : \(response.message!)")
                    
                }catch {
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    func search(searchText:String) {
        print("Yemek ara : \(searchText)")
    }
    
    func getFood (searchText:String) {
                
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do{
                    let response = try JSONDecoder().decode(FoodResponse.self, from: data)
                    if let list = response.yemekler{
                        if !searchText.isEmpty && list.count>0
                        {
                            let filter = list.filter { $0.yemek_adi!.lowercased().contains(searchText.lowercased()) }
                            self.foodList.onNext(filter)
                            
                        }else{
                            self.foodList.onNext(list)
                        }
        
                        if let foodPriceString = list[0].yemek_fiyat, let urunFiyat = Int(foodPriceString) {
                            self.foodTotalPrice.onNext(urunFiyat)
                        } else {
                            print("Error")
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    
        
    }
    
    func getBasket (kullanici_adi:String) {
        let params:Parameters = ["kullanici_adi":kullanici_adi]
                AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php",method: .post,parameters: params).response {
                    response in
                    guard let data = response.data else {
                        print("No data")
                        return
                    }
                        do{
                           
                            let response = try JSONDecoder().decode(BasketResponse.self, from: data)
                               //success
                            guard var basketDetail = response.sepet_yemekler else {
                                print("No basketDetail")
                                return
                            }
                            basketDetail.sort(by: { (firstId, secondId) -> Bool in
                        let id1 = Int(firstId.sepet_yemek_id ?? "") ?? 0
                        let id2 = Int(secondId.sepet_yemek_id ?? "") ?? 0
                        return id1 < id2
                        })
                            var foodGroups: [String: (totalAdet: Int, totalPrice: Double)] = [:]
                            
                            for detail in basketDetail {
                                if let yemekAdi = detail.yemek_adi, let adetStr = detail.yemek_siparis_adet, let adet = Int(adetStr), let fiyatStr = detail.yemek_fiyat, let fiyat = Double(fiyatStr) {
                                    let current = foodGroups[yemekAdi] ?? (0, 0.0)
                                    foodGroups[yemekAdi] = (current.totalAdet + adet, current.totalPrice + (fiyat * Double(adet)))
                                }
                            }
                            let updateList = foodGroups.map{ (yemekAdi, info) -> BasketFood in
                            let newDetail = BasketFood()
                               newDetail.yemek_adi = yemekAdi
                               newDetail.yemek_siparis_adet = String(info.totalAdet)
                               newDetail.toplam_fiyat = String(info.totalPrice)
                                
                                newDetail.yemek_resim_adi = basketDetail.first(where: { $0.yemek_adi == yemekAdi })?.yemek_resim_adi
                                newDetail.sepet_yemek_id = basketDetail.first(where: { $0.yemek_adi == yemekAdi })?.sepet_yemek_id
                                newDetail.kullanici_adi = basketDetail.first(where: { $0.yemek_adi == yemekAdi })?.kullanici_adi
                                newDetail.yemek_fiyat = basketDetail.first(where: { $0.yemek_adi == yemekAdi })?.yemek_fiyat
                                
                                newDetail.idList = basketDetail.filter { $0.yemek_adi == yemekAdi }.map {
                                    $0.sepet_yemek_id}
                                return newDetail
                            }
                            self.basketList.onNext(updateList)
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
    }

