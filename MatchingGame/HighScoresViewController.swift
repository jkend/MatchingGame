//
//  HighScoresViewController.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/6/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController {

    @IBOutlet weak var clearScoreButton: UIButton!
    
    @IBOutlet weak var scoresTextView: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scoresTextView.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: UIFontWeightBold)
        updateUI()
    }
    
    private func updateUI() {
        let scoreArray = HighScores.getScores()
        print(scoreArray)
        if scoreArray.count == 0 {
            clearScoreButton.isHidden = true
            scoresTextView.text = "No high scores - play a game!"
        }
        else {
            clearScoreButton.isHidden = false
            var scoreText = ""
            for i in 0..<scoreArray.count {
                scoreText += "\(i+1).     \(HighScores.timeString(fromSeconds: scoreArray[i]))\n"
            }
            scoresTextView.text = scoreText
        }
    }

    @IBAction func clearAllScores() {
        HighScores.clearScores()
        updateUI()
    }
}
