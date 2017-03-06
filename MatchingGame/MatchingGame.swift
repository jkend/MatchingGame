//
//  MatchingGame.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/2/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import Foundation

class MatchingGame {
    
    private var tileList = [String]()
    private var tileDeck = [String]()
    private var tileSet = Set<String>()
    
    init(_ tileImages: Array<String>) {
        tileList = tileImages
        for img in tileImages {
            tileDeck.append(img)
            tileDeck.append(img) // do it twice
        }
    }
    
    func newGame() {
        shuffle()
        tileSet.removeAll(keepingCapacity: true)
        for img in tileList {
            tileSet.insert(img)
        }
    }
    
    func matches(firstIndex: Int, withIndex: Int) -> Bool {
        if tileDeck[firstIndex] == tileDeck[withIndex] {
            let tileName = tileDeck[firstIndex]
            tileSet.remove(tileName)
            return true
        }
        return false
    }
    
    func tileAtIndex(index: Int) -> String {
        return tileDeck[index]
    }
    
    func gameOver() -> Bool {
        return tileSet.isEmpty
    }
    
    private func shuffle() {
        var switchInd: Int
        var temp: String
        for i in 0..<tileDeck.count {
            switchInd = Int(arc4random_uniform(UInt32(i)))
            temp = tileDeck[switchInd]
            tileDeck[switchInd] = tileDeck[i]
            tileDeck[i] = temp
        }
    }
}
