//
//  ParserModel.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 4/29/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import Foundation

struct AreaAndTurnsSpent {
    let zone: String
    let turnsSpent: Int
}

struct LevelAndTurnsSpent {
    let level: Int
    let turnsSpent: Int
    let combatTurnsSpent: Int
    let nonCombatTurnsSpent: Int
    let otherTurnsSpent: Int
}

struct TurnGain{
    let eating: Int
    let drinking: Int
    // Chocolates and other uses
    let using: Int
    // Daily gains
    let rollover: Int
}

struct MeatGainAndLoss {
    let level: Int
    let meatGained: Int
    let meatSpent: Int
}

//regex pattern matcher
//https://stackoverflow.com/questions/27880650/swift-extract-regex-matches/27880748
func matchRegex(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

class ParserModel {
    var documentText: String
    var lines: [String]
    // For generating horizontal chart of area and turns spent in area
    // No Sort, leave as list
    var turnsSpentPerArea: [AreaAndTurnsSpent]
    // For generating horizontal chart of levels and turns spent in level
    // Sort by Level, already sorted
    var turnsSpentPerLevel: [LevelAndTurnsSpent]
    // For generating pie chart of all four turn gain avenues
    var turnGains: TurnGain
    // For generating positive/negative bar chart for each level of meat gained
    var meatNet: [MeatGainAndLoss]
    
    init(documentText: String){
        self.documentText = documentText
        self.lines = documentText.components(separatedBy: "\n")
        self.turnsSpentPerArea = []
        self.turnsSpentPerLevel = []
        self.turnGains = TurnGain(eating: 0, drinking: 0, using: 0, rollover: 0)
        self.meatNet = []
    }
    
    func parse(){
        // Parse line by line
        for (index, line) in lines.enumerated(){
            
            // Adventure by zone block
            if line == "ADVENTURES"{
                self.turnsSpentPerArea = parseTurnsSpentPerArea(startingIndex: index)
            }
            
            // Adventure by level
            if line == "LEVELS"{
                self.turnsSpentPerLevel = parseTurnsSpentPerLevel(startingIndex: index)
            }
            
            // Turn Gain by source
            if line == "EATING AND DRINKING AND USING"{
                self.turnGains = parseTurnGain(startingIndex: index)
            }
            
            // Meat loss and gain by level
            if line == "MEAT"{
                self.meatNet = parseMeatNet(startingIndex: index)
            }
        }
    }
    
    func parseTurnsSpentPerArea(startingIndex: Int) -> [AreaAndTurnsSpent]{
        // Lines go
        // index - ADVENTURES
        // index + 1 - --------
        // index + 2 - AREA: TURNS
        // index 2 repeat ...
        // index end - blank or QUEST TURNS
        
        var returnTurnsSpentPerArea: [AreaAndTurnsSpent] = []
        var indexEnd = true
        var index = startingIndex + 2
        while(indexEnd){
            let line = lines[index]
            if line.contains(":"){
                
                
                let areaAndTurn = line.components(separatedBy: ":")
                let data = AreaAndTurnsSpent(zone: areaAndTurn[0], turnsSpent: Int(areaAndTurn[1])!)
                returnTurnsSpentPerArea.append(data)
                index += 1
            }else{
                indexEnd = false
            }
        }
        return returnTurnsSpentPerArea
    }
    
    func parseTurnsSpentPerLevel(startingIndex: Int) -> [LevelAndTurnsSpent]{
        // Lines go
        // index - LEVELS
        // index + 1 - --------
        // index + 2 - Hit level x on turn y(n), y(n-1) - y(n) from last level. (z substats / turn
        // index + 3 - Combats: c
        // index + 4 - Noncombats: nc
        // index + 5 - Other: o
        // index 2-5 repeat ...
        // index end - blank or total combats etc
        
        var returnLevelAndTurnsSpent: [LevelAndTurnsSpent] = []
        var indexEnd = true
        var index = startingIndex + 2
        while(indexEnd){
            let line = lines[index]
            if line.contains("Hit"){
                let patternDigits = "\\d+"
                var matches = matchRegex(for: patternDigits, in: line)
                
                let level = matches[0]
                let turnsSpent = matches[1]
                
                // combat turns
                let combatLine = lines[index+1]
                
                matches = matchRegex(for: patternDigits, in: combatLine)
                let combat = matches[0]
                
                // noncombat turns
                let nonCombatLine = lines[index+2]
                
                matches = matchRegex(for: patternDigits, in: nonCombatLine)
                let nonCombat = matches[0]
                
                // other turns
                let otherLine = lines[index+3]
                
                matches = matchRegex(for: patternDigits, in: otherLine)
                let other = matches[0]
                
                let data = LevelAndTurnsSpent(level: Int(level)!, turnsSpent: Int(turnsSpent)!, combatTurnsSpent: Int(combat)!, nonCombatTurnsSpent: Int(nonCombat)!, otherTurnsSpent: Int(other)!)
                returnLevelAndTurnsSpent.append(data)
                index += 4
            }else{
                indexEnd = false
            }
        }
        return returnLevelAndTurnsSpent
    }
    
    func parseTurnGain(startingIndex: Int) -> TurnGain{
        // Lines go
        // index - ADVENTURES
        // index + 1 - --------
        // index + 2 - Adventures gained eating: x
        // index + 3 - Adventures gained drinking: y
        // index + 4 - Adventures gained using: z
        // index + 5 - Adventures gained rollover: a
        // index end - blank or ate x or MEAT
        
        var index = startingIndex + 2
        
        let eating = lines[index].components(separatedBy: ":")
        index += 1
        
        let drinking = lines[index].components(separatedBy: ":")
        index += 1
        
        let using = lines[index].components(separatedBy: ":")
        index += 1
        
        let rollover = lines[index].components(separatedBy: ":")
        
        let returnTurnGain: TurnGain = TurnGain(eating: Int(eating[1])!, drinking: Int(drinking[1])!, using: Int(using[1])!, rollover: Int(rollover[1])!)
        
        return returnTurnGain
    }
    
    func parseMeatNet(startingIndex: Int) -> [MeatGainAndLoss]{
        // Lines go
        // index - ADVENTURES
        // index + 1 - --------
        // index + 2 - Total meat gained: x
        // index + 3 - Total meat spent: y
        // index + 4 - Blank
        // index + 5 - Level x:
        // index + 6 - Meat gain inside Encounters: Ei
        // index + 7 - Meat gain outside Encounters: Eo
        // index + 8 - Meat spent: s
        // index 5-8 repeat ...
        // index end - blank or BOTTLENECKS
        
        var returnMeatGainAndLoss: [MeatGainAndLoss] = []
        var indexEnd = true
        var index = startingIndex + 5
        while(indexEnd){
            let line = lines[index]
            if line.contains("Hit"){
                let patternDigits = "\\d+"
                var matches = matchRegex(for: patternDigits, in: line)
                
                let level = matches[0]
                
                // combat turns
                let meatGainedInsideLine = lines[index+1]
                
                matches = matchRegex(for: patternDigits, in: meatGainedInsideLine)
                let meatGainedInside = matches[0]
                
                // noncombat turns
                let meatGainedOutsideLine = lines[index+2]
                
                matches = matchRegex(for: patternDigits, in: meatGainedOutsideLine)
                let meatGainedOutside = matches[0]
                
                // other turns
                let meatSpentLine = lines[index+3]
                
                matches = matchRegex(for: patternDigits, in: meatSpentLine)
                let meatSpent = matches[0]
                
                let meatGained = Int(meatGainedInside)! + Int(meatGainedOutside)!
                
                
                let data = MeatGainAndLoss(level: Int(level)!, meatGained: meatGained, meatSpent: Int(meatSpent)!)
                returnMeatGainAndLoss.append(data)
                
                index += 4
            }else{
                indexEnd = false
            }
        }
        return returnMeatGainAndLoss
    }
}
