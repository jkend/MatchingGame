//
//  MatchingGameViewController.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/1/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

class MatchingGameViewController: UIViewController {

    @IBOutlet var tileButtons: [UIButton]!
    @IBOutlet weak var timerLabel: UILabel!
    
    private var cards = Array<String>()
    private lazy var matchingGame: MatchingGame? = self.gameSetup()
    private var firstButtonInd = -1
    
    var gameTimer = Timer()
    var tileFlipTimer = Timer()
    var gameSeconds : Int = 0 {
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

    
    override func viewWillAppear(_ animated: Bool) {
        self.startNewGame()
    }
    
    private func gameSetup() -> MatchingGame? {
        guard let imageArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "squares") else {
            print ("couldn't get image array")
            return nil
        }
        
        for pic in imageArray {
            //cards.append(pic.lastPathComponent)
            cards.append(pic.path)
        }
        let game = MatchingGame(tileImages: cards)
        return game
        
    }

    // MARK: Click on a tile
    @IBAction func chooseTile(_ sender: UIButton) {
        let tileInd = tileButtons.index(of: sender)!
        print(tileInd)
        let tileImg = self.matchingGame?.tileAtIndex(index: tileInd)
        
        // a tile has been clicked on, see what we should do
        // If we just clicked on it, then flip it back over
        if firstButtonInd == tileInd {
            self.flipFaceDown(sender)
            firstButtonInd = -1
        }
        // If no other tile has been chosen, this is our first
        // choice; show it
        else if (firstButtonInd == -1) {
            firstButtonInd = tileInd
            self.flipFaceUp(sender, usingImage:tileImg!)
        }
        
        else {
            // this is the second tile chosen, see if it matches
            if (matchingGame?.matches(firstIndex: firstButtonInd, withIndex: tileInd))! {
                self.showTilesMatched(firstButtonInd, secondIndex: tileInd)
                firstButtonInd = -1
                if (matchingGame?.gameOver())! {
                    self.stopTimer()
                }
            }
            else {
                self.flipFaceUp(sender, usingImage: tileImg!)
                tileFlipTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) {
                    [weak self] timer in
                    //Add a guard statement to bail out of the timer code if the object has been freed.
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.flipFaceDown(sender)
                    strongSelf.flipFaceDown(strongSelf.tileButtons[strongSelf.firstButtonInd])
                    strongSelf.firstButtonInd = -1
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
    
    private func showTilesMatched(_ firstIndex:Int, secondIndex: Int) {
        let button1 = tileButtons[firstIndex]
        let button2 = tileButtons[secondIndex]
        let imgPath = self.matchingGame?.tileAtIndex(index: firstIndex)
        self.flipFaceUpAndDisable(button1, usingImage: imgPath!)
        self.flipFaceUpAndDisable(button2, usingImage: imgPath!)
    }
    
    private func flipFaceUpAndDisable(_ tileButton: UIButton, usingImage: String) {
        tileButton.isEnabled = false
        tileButton.setImage(UIImage(contentsOfFile: usingImage), for: UIControlState.disabled)
    }
    
    // MARK: Start a new game
    @IBAction private func startNewGame() {
        stopTimer()
        matchingGame?.newGame()
        resetBoard()
        startTimer()
    }
    
    private func resetBoard() {
        for tile in tileButtons {
            tile.isEnabled = true
            tile.setImage(UIImage(named:"bg"), for: UIControlState.normal)
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
