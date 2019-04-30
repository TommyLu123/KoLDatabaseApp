//
//  DatabaseModel.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 4/29/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//


import Foundation

struct Candy {
    let category : String
    let name : String
}


// Food    Fullness    Level Req    quality    Adv    Musc    Myst    Moxie
struct Food {
    // Food
    let name : String
    // Fullness
    let fullness : Int
    // Level Req
    let level : Int
    // Quality, could be struct, not necessary
    let quality : String
    // Adv
    let adv : Int
    // Musc
    let musc : Int
    // Myst
    let myst : Int
    // Mox
    let mox : Int
    
}

// Drink    Inebriety    Level Req    quality    Adv    Musc    Myst    Moxie
struct Drink {
    // Drink
    let name : String
    // Inebriety
    let inebriety : Int
    // Level Req
    let level : Int
    // Quality, could be struct, not necessary
    let quality : String
    // Adv
    let adv : Int
    // Musc
    let musc : Int
    // Myst
    let myst : Int
    // Mox
    let mox : Int
}

// item number    name    descid    image    use    access    autosell    plural
struct Item {
    // Item Number
    let ID : Int
    // Name
    let name : String
    // use should be food/drink/etc. Matters in some cases, should have struct for clarity
    let use : String
    // Autosell
    let autosell : Int
}
// Type name    Modifiers
struct Modifiers {
    // Type
    let type : String
    // Name
    let name : String
    // modifiers take many forms (Effect: x, Effect: duration, Moxie Percentage: +x, Free Pull). Some do not have modifiers, some with good categories do.
    let modifiers : [String: String]
}

class ItemsModel {
    // Item database where key is name, and value is item struct
    var foodDatabase : [String: Food]
    var drinkDatabase : [String: Drink]
    var itemDatabase : [String: Item]
    var modifierDatabase : [String: Modifiers]
    
    init() {
        foodDatabase = ItemsModel.generateFoodDatabase()
        drinkDatabase = ItemsModel.generateDrinkDatabase()
        itemDatabase = ItemsModel.generateItemDatabase()
        modifierDatabase = ItemsModel.generateModifierDatabase()
    }
    
    static func generateFoodDatabase() -> [String: Food]{
        let foo : [String: Food] = [:]
        return foo
    }
    
    static func generateDrinkDatabase() -> [String: Drink]{
        let foo : [String: Drink] = [:]
        return foo
    }
    
    static func generateItemDatabase() -> [String: Item]{
        let foo : [String: Item] = [:]
        return foo
    }
    
    static func generateModifierDatabase() -> [String: Modifiers]{
        let foo : [String: Modifiers] = [:]
        return foo
    }
}
