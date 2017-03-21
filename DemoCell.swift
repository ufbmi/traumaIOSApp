//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import SwiftyJSON

class DemoCell: FoldingCell {

    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    let tensteps:TenSteps = TenSteps()
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        let durations = [0.1, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
           selectedAnimation(false, animated: false, completion: nil)

        
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func updateSummaryLabel(IndexPath:IndexPath) {
        summaryLabel.text = tensteps.arrayOfStepSummary[(IndexPath as NSIndexPath).row]
    }

    
    
}
