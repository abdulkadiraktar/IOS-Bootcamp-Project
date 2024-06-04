//
//  BasketFood.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import Foundation

class BasketFood : Codable {
    var sepet_yemek_id:String?
    var yemek_adi:String?
    var yemek_resim_adi:String?
    var yemek_fiyat:String?
    var yemek_siparis_adet:String?
    var kullanici_adi:String?
    var toplam_fiyat:String?
    var idList:[String?]?
    
    init() {
        self.idList = []
    }
    init(sepet_yemek_id: String, yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: String, yemek_siparis_adet: String, kullanici_adi: String,toplam_fiyat:String) {
        self.sepet_yemek_id = sepet_yemek_id
        self.yemek_adi = yemek_adi
        self.yemek_resim_adi = yemek_resim_adi
        self.yemek_fiyat = yemek_fiyat
        self.yemek_siparis_adet = yemek_siparis_adet
        self.kullanici_adi = kullanici_adi
        self.toplam_fiyat = toplam_fiyat
    }
    
    func calculate() {
        if let price = Double(yemek_fiyat ?? "0"), let adet =
            Double(yemek_siparis_adet ?? "0") {
            let total = price * adet
            toplam_fiyat = "\(total)"
        }
    }
}
