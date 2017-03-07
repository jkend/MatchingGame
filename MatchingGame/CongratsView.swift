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

    @IBOutlet var view: UIView!

    
    @IBOutlet private weak var timeReportLabel: UILabel!
    var timeString: String? {
        didSet {
            if timeString != nil {
                timeReportLabel.text = "You did it in \(timeString!) !"
            }
        }
    }
    
    @IBAction func dismissMe() {
        //self.isHidden = true
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
