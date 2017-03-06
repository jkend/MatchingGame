//
//  MatchingGameViewController.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/1/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

class MatchingGameViewController: UIViewController {

    @IBOutlet private var tileButtons: [UIButton]!
    @IBOutlet private weak var timerLabel: UILabel!
    
    private lazy var matchingGame: MatchingGame? = self.gameSetup()
    private var firstButtonInd: Int?
    
    var gameTimer = Timer()
    var tileFlipTimer = Timer()
    private var gameSeconds : Int = 0 {
        didSet {
            let hours = gameSeconds / 3600
            let minutes = gameSeconds / 60 % 60
            let seconds = gameSeconds % 60
            if hours > 0 {
                timerLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
            } else {
                timerLabel.text = String(format: "%02i:%02i", minutes, seconds)
            }            
        }
    }

    // MARK: Setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startNewGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameTimer.invalidate()
        tileFlipTimer.invalidate()
    }
    
    private func gameSetup() -> MatchingGame? {
        guard let imageArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "squares") else {
            print ("couldn't get image array")
            return nil
        }
        var cards = Array<String>()
        for pic in imageArray {
            //cards.append(pic.lastPathComponent)
            cards.append(pic.path)
        }
        let game = MatchingGame(cards)
        return game
        
    }

    // MARK: Click on a tile
    @IBAction func chooseTile(_ sender: UIButton) {
        let tileInd = tileButtons.index(of: sender)!
        let tileImg = self.matchingGame?.tileAtIndex(index: tileInd)
        
        // First, if we're in the middle of a "non match",
        // fire that timer immediately.
        if tileFlipTimer.isValid {
            tileFlipTimer.fire()
        }
        
        // Okay, now let's see what to do with this clicked tile!
        
        // If no other tile has been chosen, this is our first choice - show it
        if firstButtonInd == nil {
            firstButtonInd = tileInd
            flipFaceUp(sender, usingImage:tileImg!)
        }

        // If we just clicked on this tile, just flip it back over
        else if firstButtonInd == tileInd {
            flipFaceDown(sender)
            firstButtonInd = nil
        }
            
        else {
            // this is the second tile chosen, see if it matches
            if (matchingGame?.matches(firstIndex: firstButtonInd!, withIndex: tileInd))! {
                
                // We got a match! Keep both cards face up and disable them.
                tileButtons[firstButtonInd!].isEnabled = false
                tileButtons[tileInd].isEnabled = false
                firstButtonInd = nil
                
                // Only need to check if game is over when we get a match
                if (matchingGame?.gameOver())! {
                    stopTimer()
                }
            }
            else {
                // The second card isn't a match.  Show it, but set a timer that
                // will flip both cards over.
                self.flipFaceUp(sender, usingImage: tileImg!)
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
    
    // MARK: Start a new game
    @IBAction private func startNewGame() {
        stopTimer()
        matchingGame?.newGame()
        resetBoard()
        startTimer()
    }
    
    private func resetBoard() {
        var tile: UIButton
        for i in 0..<tileButtons.count {
            tile = tileButtons[i]
            tile.isEnabled = true
            tile.setImage(UIImage(contentsOfFile: (matchingGame?.tileAtIndex(index: i))!), for: UIControlState.disabled)
            flipFaceDown(tile)
        }
    }

    // MARK: Game timer
    private func startTimer() {
        stopTimer() // just in case
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        gameSeconds += 1
    }
    
    private func stopTimer() {
        gameTimer.invalidate()
        gameSeconds = 0
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
