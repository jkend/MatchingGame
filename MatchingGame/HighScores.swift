//
//  HighScores.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/6/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import Foundation

class HighScores {
    
    static func addScore(_ time: Int) {
        var scores = getScores()
        scores.append(time)
        scores.sort()
        saveScores(scores)
    }
    
    static func getScores() -> [Int] {
        let defaults = UserDefaults.standard
        let scores = defaults.object(forKey: "topscores") as? [Int] ?? [Int]()
        return scores
    }
    
    static func clearScores() {
        var scores = getScores()
        scores.removeAll()
        saveScores(scores)
    }
    
    private static func saveScores(_ scoreArray: [Int]) {
        let defaults = UserDefaults.standard
        defaults.set(scoreArray, forKey: "topscores")
    }
}
