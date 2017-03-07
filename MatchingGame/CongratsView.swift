//
//  CongratsView.swift
//  MatchingGame
//
//  Created by Joy Kendall on 3/7/17.
//  Copyright © 2017 Joy. All rights reserved.
//

import UIKit

@IBDesignable
class CongratsView: UIView {
    // MARK: outlets
    @IBOutlet var view: UIView!

    @IBOutlet weak var congratsTopLabel: UILabel!
    
    @IBOutlet weak var congratsBottomLabel: UILabel!
    @IBOutlet private weak var timeReportLabel: UILabel!
    
    private let congratsTop = ["Yesss!", "W00t!", "Nice!", "Yeah!"]
    private let congratsBottom = ["Good job!", "You go!", "Awesome!", "You got this."]
    
    var timeString: String? {
        didSet {
            if timeString != nil {
                updateLabelText()
            }
        }
    }
    
    // MARK: update UI
    private func updateLabelText() {
        timeReportLabel.text = "You did it in \(timeString!) !"
        let ind1 = Int(arc4random_uniform(UInt32(congratsTop.count)))
        let ind2 = Int(arc4random_uniform(UInt32(congratsBottom.count)))
        congratsTopLabel.text = congratsTop[ind1]
        congratsBottomLabel.text = congratsBottom[ind2]
    }
    
    // MARK: show and hide
    @IBAction func dismissMe() {
        setHiddenState(true)
    }
    
    func showMe() {
        setHiddenState(false)
    }
    
    private func setHiddenState(_ hidden: Bool) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {() -> Void in
            self.isHidden = hidden
        }, completion: { _ in })
        
    }
    
    // MARK: init/load from nib
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Add custom subview on top of our view
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: CongratsView.self)
        let nib = UINib(nibName: "CongratsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
