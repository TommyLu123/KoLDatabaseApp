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
        var returnDictionary : [String: Item] = [:]
        NSLog("Generating Items")
        let filePath = Bundle.main.path(forResource: "items", ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        
        do {
            let string = try String.init(contentsOf: URL, encoding: .utf8)
            var lines = string.split(separator: "\n")
            for line in lines{
                NSLog(String(line))
                // Ignored "commented" out lines
                if String(line).first == "#"{
                    continue
                }
                let categories = line.components(separatedBy: "\t")
                // item number    name    descid    image    use    access    autosell    plural
                // Ignore unknown item ids
                if categories.count == 1{
                    continue
                }
                
                for category in categories{
                    NSLog(String(category))
                }
                
                let newItem = Item(ID: Int(categories[0])!, name: String(categories[1]), use: String(categories[4]), autosell: Int(categories[6])!)
                returnDictionary[newItem.name] = newItem
            }
        } catch  {
            print(error);
        }
        
        return returnDictionary
    }
    
    static func generateModifierDatabase() -> [String: Modifiers]{
        let foo : [String: Modifiers] = [:]
        return foo
    }
}
