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
    
    var gameTimer = Timer()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectImages()
    }
    
    private func collectImages() {
        guard let imageArray = Bundle.main.urls(forResourcesWithExtension: "jpg", subdirectory: "squares") else {
            print ("couldn't get image array")
            return
        }
        
        for pic in imageArray {
            cards.append(pic.lastPathComponent)
        }
    }
    
    @IBAction private func startNewGame() {
        stopTimer()
        resetBoard()
        startTimer()
    }
    
    private func resetBoard() {
        for tile in tileButtons {
            tile.setImage(UIImage(named:"bg"), for: UIControlState.normal)
        }
    }

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
