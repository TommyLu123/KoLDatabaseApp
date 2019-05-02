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
    let meatLost: Int
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
    // Tuple to perserve order
    var turnsSpentPerArea: [AreaAndTurnsSpent]
    var turnsSpentPerLevel: [LevelAndTurnsSpent]
    var turnGains: TurnGain
    
    init(documentText: String){
        self.documentText = documentText
        self.lines = documentText.components(separatedBy: "\n")
        self.turnsSpentPerArea = []
        self.turnsSpentPerLevel = []
        self.turnGains = TurnGain(eating: 0, drinking: 0, using: 0, rollover: 0)
    }
    
    func parse(){
        // Parse line by line
        for (index, line) in lines.enumerated(){
            
            // Adventure by zone block
            if line == "ADVENTURES"{
                self.turnsSpentPerArea = parseTurnsSpentPerArea(startingIndex: index)
            }
            
            if line == "LEVELS"{
                self.turnsSpentPerLevel = parseTurnsSpentPerLevel(startingIndex: index)
            }
            
            if line == "EATING AND DRINKING AND USING"{
                self.turnGains = parseTurnGain(startingIndex: index)
            }
            
        }
    }
    
    func parseTurnsSpentPerArea(startingIndex: Int) -> [AreaAndTurnsSpent]{
        // Lines go
        // index - ADVENTURES
        // index + 1 - --------
        // index + 2 - AREA: TURNS
        // index + ...
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
            }else{
                indexEnd = false
            }
            index += 1
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
        // index + ...
        // index end - blank or QUEST TURNS
        
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
            }else{
                indexEnd = false
            }
            index += 4
        }
        return returnLevelAndTurnsSpent
    }
    
    func parseTurnGain(startingIndex: Int) -> TurnGain{
        // Lines go
        // index - ADVENTURES
        // index + 1 - --------
        // index + 2 - Adventures gained eating: 69
        // index + 3 - Adventures gained drinking: 89
        // index + 4 - Adventures gained using: 0
        // index + 5 - Adventures gained rollover: 41
        // index + ...
        // index end - blank or QUEST TURNS
        
        var indexEnd = true
        var index = startingIndex + 2
        
        let eating = lines[index].components(separatedBy: ":")
        index += 1
        
        let drinking = lines[index].components(separatedBy: ":")
        index += 1
        
        let using = lines[index].components(separatedBy: ":")
        index += 1
        
        let rollover = lines[index].components(separatedBy: ":")
        
        var returnTurnGain: TurnGain = TurnGain(eating: Int(eating[1])!, drinking: Int(drinking[1])!, using: Int(using[1])!, rollover: Int(rollover[1])!)
        
        return returnTurnGain
    }
    
}
