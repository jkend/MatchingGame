//
//  HighScores.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/6/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import Foundation

class HighScores {
    static let maxScores = 10
    
    static func addScore(_ time: Int) {
        var scores = getScores()
        if scores.count < maxScores || (scores.count == maxScores && time < scores.last!)  {
            if scores.count == maxScores {
                scores.removeLast()
            }
            scores.append(time)
            scores.sort()
            saveScores(scores)
        }
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
    
    static func timeString(fromSeconds: Int) -> String {
        let hours = fromSeconds / 3600
        let minutes = fromSeconds / 60 % 60
        let seconds = fromSeconds % 60
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
    
    private static func saveScores(_ scoreArray: [Int]) {
        let defaults = UserDefaults.standard
        defaults.set(scoreArray, forKey: "topscores")
    }
}
