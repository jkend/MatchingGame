//
//  MatchingGameViewController.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/1/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit
import QuartzCore

class MatchingGameViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet private var tileButtons: [UIButton]!
    @IBOutlet private weak var timerLabel: UILabel!
    
    @IBOutlet weak var congratsPopup: CongratsView!
    // MARK: Other properties
    private lazy var matchingGame: MatchingGame = self.gameSetup()
    private var firstButtonInd: Int?
    
    var gameTimer = Timer()
    var tileFlipTimer = Timer()
    private var gameSeconds : Int = 0 {
        didSet {
            timerLabel.text = HighScores.timeString(fromSeconds: gameSeconds)
        }
    }

    // MARK: Setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 18, weight: UIFontWeightRegular)
        startNewGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllTimers()
    }
    
    private func gameSetup() -> MatchingGame {
        let imageArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "squares")
        var cards = [String]()
        for pic in imageArray! {
            cards.append(pic.path)
        }
        let game = MatchingGame(cards)
        return game
        
    }

    // MARK: Click on a tile
    @IBAction func chooseTile(_ sender: UIButton) {
        let tileInd = tileButtons.index(of: sender)!
        let tileImg = self.matchingGame.tileAtIndex(index: tileInd)
        
        // First, if we're in the middle of a "non match",
        // fire that timer immediately.
        if tileFlipTimer.isValid {
            tileFlipTimer.fire()
        }
        
        // Okay, now let's see what to do with this clicked tile!
        
        // If no other tile has been chosen, this is our first choice - show it
        if firstButtonInd == nil {
            firstButtonInd = tileInd
            flipFaceUp(sender, usingImage:tileImg)
        }

        // If we just clicked on this tile, just flip it back over
        else if firstButtonInd == tileInd {
            flipFaceDown(sender)
            firstButtonInd = nil
        }
            
        else {
            // this is the second tile chosen, see if it matches
            if (matchingGame.matches(firstIndex: firstButtonInd!, withIndex: tileInd)) {
                
                // We got a match! Keep both cards face up and disable them.
                tileButtons[firstButtonInd!].isEnabled = false
                tileButtons[tileInd].isEnabled = false
                firstButtonInd = nil
                
                // Only need to check if game is over when we get a match
                if (matchingGame.gameOver()) {
                    handleGameOver()
                }
            }
            else {
                // The second card isn't a match.  Show it, but set a timer that
                // will flip both cards over.
                self.flipFaceUp(sender, usingImage: tileImg)
                tileFlipTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {
                    [weak self] timer in
                    
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.flipFaceDown(sender)
                    strongSelf.flipFaceDown(strongSelf.tileButtons[strongSelf.firstButtonInd!])
                    strongSelf.firstButtonInd = nil
                }
            }
            
        }
    }
    
    // MARK: Actions on clicked cards
    private func flipFaceDown(_ tileButton: UIButton) {
        tileButton.setImage(UIImage(named:"bg"), for: UIControlState.normal)
    }
    
    private func flipFaceUp(_ tileButton: UIButton, usingImage: String) {
        tileButton.setImage(UIImage(contentsOfFile: usingImage), for: UIControlState.normal)
    }
    
    // MARK: New game
    @IBAction private func startNewGame() {
        stopAllTimers()
        matchingGame.newGame()
        resetBoard()
        startGameTimer()
        congratsPopup.dismissMe()
    }
    
    private func resetBoard() {
        var tile: UIButton
        for i in 0..<tileButtons.count {
            tile = tileButtons[i]
            tile.isEnabled = true
            tile.setImage(UIImage(contentsOfFile: matchingGame.tileAtIndex(index: i)), for: UIControlState.disabled)
            flipFaceDown(tile)
        }
        firstButtonInd = nil
    }

    // MARK: Game over
    private func handleGameOver() {
        stopGameTimer()
        HighScores.addScore(gameSeconds)
        congratsPopup.timeString = HighScores.timeString(fromSeconds: gameSeconds)
        congratsPopup.showMe()
    }
    
    // MARK: Game timer
    private func startGameTimer() {
        stopGameTimer() // just in case
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateGameTimer), userInfo: nil, repeats: true)
    }
    
    func updateGameTimer() {
        gameSeconds += 1
    }
    
    private func stopGameTimer() {
        gameTimer.invalidate()
    }
    
    private func stopAllTimers() {
        gameTimer.invalidate()
        tileFlipTimer.invalidate()
        gameSeconds = 0
    }

}
