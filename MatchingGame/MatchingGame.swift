//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/2/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import Foundation

class MatchingGame {
    
    private var tileList = Array<String>()
    private var tileDeck = Array<String>()
    private var tileSet = Set<String>()
    
    init(tileImages: Array<String>) {
        self.tileList = tileImages
        for img in tileImages {
            //self.tileSet.insert(img)
            self.tileDeck.append(img)
            self.tileDeck.append(img) // do it twice
        }
    }
    
    func newGame() {
        self.shuffle()
        self.tileSet.removeAll(keepingCapacity: true)
        for img in self.tileList {
            self.tileSet.insert(img)
        }
    }
    
    func matches(firstIndex: Int, withIndex: Int) -> Bool {
        if self.tileDeck[firstIndex] == tileDeck[withIndex] {
            let tileName = self.tileDeck[firstIndex]
            self.tileSet.remove(tileName)
            return true
        }
        return false
    }
    
    func tileAtIndex(index: Int) -> String {
        return self.tileDeck[index]
    }
    
    func gameOver() -> Bool {
        return self.tileSet.isEmpty
    }
    
    private func shuffle() {
        var switchInd: Int
        var temp: String
        for i in 0...self.tileDeck.count-1 {
            switchInd = Int(arc4random_uniform(UInt32(i)))
            temp = self.tileDeck[switchInd]
            self.tileDeck[switchInd] = self.tileDeck[i]
            self.tileDeck[i] = temp
        }
    }
}
