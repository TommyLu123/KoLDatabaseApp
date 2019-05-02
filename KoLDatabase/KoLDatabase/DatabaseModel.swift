//
//  DatabaseModel.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 4/29/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//


import Foundation

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
    let adv : String
    // Musc
    let musc : String
    // Myst
    let myst : String
    // Mox
    let mox : String
    
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
    let adv : String
    // Musc
    let musc : String
    // Myst
    let myst : String
    // Mox
    let mox : String
}

//name  power   requirements
struct Equipment {
    // Name
    let name : String
    // Power
    let power : Int
    // requirements
    let requirements : String
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
    let modifiersList : [String]
}

class ItemsModel {
    // Item database where key is name, and value is item struct
    var foodDatabase : [String: Food]
    var drinkDatabase : [String: Drink]
    var equipmentDatabase : [String: Equipment]
    var itemDatabase : [String: Item]
    var modifierDatabase : [String: Modifiers]
    var itemTable : [Item]
    
    init() {
        foodDatabase = ItemsModel.generateFoodDatabase()
        drinkDatabase = ItemsModel.generateDrinkDatabase()
        equipmentDatabase = ItemsModel.generateEquipmentDatabase()
        let itemDatabaseValues = ItemsModel.generateItemDatabase()
        itemDatabase = itemDatabaseValues.0
        itemTable = itemDatabaseValues.1
        modifierDatabase = ItemsModel.generateModifierDatabase()
    }
    
    static func generateFoodDatabase() -> [String: Food]{
        var returnDictionary : [String: Food] = [:]
        NSLog("Generating Foods")
        let filePath = Bundle.main.path(forResource: "fullness", ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        
        do {
            let string = try String.init(contentsOf: URL, encoding: .utf8)
            let lines = string.split(separator: "\n")
            for line in lines{
                // Ignored "commented" out lines
                if String(line).first == "#"{
                    continue
                }
                let categories = line.components(separatedBy: "\t")
                // Ignore unknown item ids
                if categories.count == 1{
                    continue
                }
                // Food    Fullness    Level Req    quality    Adv    Musc    Myst    Moxie
                let newFood = Food(name: categories[0], fullness: Int(categories[1])!, level: Int(categories[2])!, quality: categories[3], adv: categories[4], musc: categories[5], myst: categories[6], mox: categories[7])
                returnDictionary[newFood.name] = newFood
            }
        } catch  {
            print(error);
        }
        
        return returnDictionary
    }
    
    static func generateDrinkDatabase() -> [String: Drink]{
        var returnDictionary : [String: Drink] = [:]
        NSLog("Generating Drinks")
        let filePath = Bundle.main.path(forResource: "inebriety", ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        
        do {
            let string = try String.init(contentsOf: URL, encoding: .utf8)
            let lines = string.split(separator: "\n")
            for line in lines{
                // Ignored "commented" out lines
                if String(line).first == "#"{
                    continue
                }
                let categories = line.components(separatedBy: "\t")
                // Ignore unknown item ids
                if categories.count == 1{
                    continue
                }
                
                // Drink    Inebriety    Level Req    quality    Adv    Musc    Myst    Moxie
                let newDrink = Drink(name: categories[0], inebriety: Int(categories[1])!, level: Int(categories[2])!, quality: categories[3], adv: categories[4], musc: categories[5], myst: categories[6], mox: categories[7])
                returnDictionary[newDrink.name] = newDrink
            }
        } catch  {
            print(error);
        }
        
        return returnDictionary
    }
    
    static func generateEquipmentDatabase() -> [String: Equipment]{
        var returnDictionary : [String: Equipment] = [:]
        NSLog("Generating Equipment")
        let filePath = Bundle.main.path(forResource: "equipment", ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        
        do {
            let string = try String.init(contentsOf: URL, encoding: .utf8)
            let lines = string.split(separator: "\n")
            for line in lines{
                // Ignored "commented" out lines
                if String(line).first == "#"{
                    continue
                }
                let categories = line.components(separatedBy: "\t")
                // Ignore unknown item ids
                if categories.count == 1{
                    continue
                }
                
                // Drink    Inebriety    Level Req    quality    Adv    Musc    Myst    Moxie
                let newEquipment = Equipment(name: categories[0], power: Int(categories[1])!, requirements: categories[2])
                returnDictionary[newEquipment.name] = newEquipment
            }
        } catch  {
            print(error);
        }
        
        return returnDictionary
    }
    
    
    static func generateItemDatabase() -> ([String: Item], [Item]){
        var returnDictionary : [String: Item] = [:]
        var returnTable : [Item] = []
        NSLog("Generating Items")
        let filePath = Bundle.main.path(forResource: "items", ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        
        do {
            let string = try String.init(contentsOf: URL, encoding: .utf8)
            let lines = string.split(separator: "\n")
            for line in lines{
                // Ignored "commented" out lines
                if String(line).first == "#"{
                    continue
                }
                let categories = line.components(separatedBy: "\t")
                // Ignore unknown item ids
                if categories.count == 1{
                    continue
                }
                
                // item number    name    descid    image    use    access    autosell    plural
                let newItem = Item(ID: Int(categories[0])!, name: String(categories[1]), use: String(categories[4]), autosell: Int(categories[6])!)
                returnDictionary[newItem.name] = newItem
                returnTable.append(newItem)
                
            }
        } catch  {
            print(error);
        }
        
        return (returnDictionary, returnTable)
    }
    
    static func generateModifierDatabase() -> [String: Modifiers]{
        var returnDictionary : [String: Modifiers] = [:]
        NSLog("Generating Modifiers")
        let filePath = Bundle.main.path(forResource: "modifiers", ofType: "txt");
        let URL = NSURL.fileURL(withPath: filePath!)
        
        do {
            let string = try String.init(contentsOf: URL, encoding: .utf8)
            let lines = string.split(separator: "\n")
            for line in lines{
                // Ignored "commented" out lines
                if String(line).first == "#"{
                    continue
                }
                let categories = line.components(separatedBy: "\t")
                // Ignore unknown item ids
                if categories.count == 1{
                    continue
                }
                
                // In this case we will be ignoring any type besides item
                if categories[0] != "Item"{
                    continue
                }
                
                // Note that some modifiers are like Familiar Effect: "something, something"
                let modifierList = categories[2].components(separatedBy: ",")
                var modifierDictionary : [String: String] = [:]
                var addModifier = 0
                for modifier in modifierList{
                    if modifier.contains(":"){
                        // Modifier has a category
                        let modifierKeyAndValue = modifier.components(separatedBy: ":")
                        modifierDictionary[modifierKeyAndValue[0]] = modifierKeyAndValue[1]
                    }
                    else{
                        // Modifier is a strange one without a known category (ex: Free Pull)
                        modifierDictionary["Additional Modifier \(addModifier)"] = modifier
                        addModifier += 1
                    }
                }
                // Type name    Modifiers
                let newModifiers = Modifiers(type: categories[0], name: categories[1], modifiers: modifierDictionary, modifiersList: modifierList)
                returnDictionary[newModifiers.name] = newModifiers
            }
        } catch  {
            print(error);
        }
        
        return returnDictionary
    }
}
