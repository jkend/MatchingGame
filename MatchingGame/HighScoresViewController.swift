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
        //scoresTextView.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: UIFontWeightBold)
        updateUI()
    }
    
    private func updateUI() {
        let scoreArray = HighScores.getScores()
        print(scoreArray)
        if scoreArray.count == 0 {
            clearScoreButton.isHidden = true
            scoresTextView.font = UIFont.systemFont(ofSize: 32, weight: UIFontWeightBold)
            scoresTextView.text = "No times to display. Play a game!"
        }
        else {
            clearScoreButton.isHidden = false
            scoresTextView.font = UIFont(name: "Menlo", size: 30)
            var scoreText = ""
            for i in 0..<scoreArray.count {
                //scoreText += "\(i+1).     \(HighScores.timeString(fromSeconds: scoreArray[i]))\n" 
                scoreText += String(format: "%2i. %@\n", (i+1), HighScores.timeString(fromSeconds: scoreArray[i]))
            }
            scoresTextView.text = scoreText
        }
    }

    @IBAction func clearAllScores() {
        HighScores.clearScores()
        updateUI()
    }
}
