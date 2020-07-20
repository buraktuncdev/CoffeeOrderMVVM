//
//  AddCoffeeOrderViewModel.swift
//  MvvmCoffeeOrderApp
//
//  Created by Burak Tunc on 20.07.2020.
//  Copyright © 2020 Burak Tunç. All rights reserved.
//

import Foundation

struct AddCoffeeOrderViewModel {
    
    var name: String?
    var email: String?
    
    var selectedType: String?
    var selectedSize: String?
    
    var types:[String] {
        return CoffeeType.allCases.map{$0.rawValue.capitalized}
    }
    
    var sizes:[String] {
        return CoffeeSize.allCases.map{$0.rawValue.capitalized}
    }
    
    
}
