//
//  HompageViewModel.swift
//  IOS Bootcamp Project
//
//  Created by Abdulkadir Aktar on 1.06.2024.
//

import Foundation
import RxSwift
import Kingfisher
class HompageViewModel {
    
    var frepo = FoodRepo()
    var foodList = BehaviorSubject<[Food]>(value: [Food]())
    
    init() {
        foodList = frepo.foodList
            }
    
    func search(searchText:String) {
        frepo.search(searchText: searchText)
    }
    func getFood (searchText:String) {
        frepo.getFood(searchText: searchText)
    }
}
