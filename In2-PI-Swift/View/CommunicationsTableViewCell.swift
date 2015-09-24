//
//  CommunicationsTableViewCell.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 9/16/15.
//  Copyright © 2015 Terry Bu. All rights reserved.
//

import UIKit

class CommunicationsTableViewCell: UITableViewCell {

    @IBOutlet weak var articleCategoryLabel: PaddedLabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var blackOverlay: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        blackOverlay = UIView(frame:self.backgroundImageView.frame)
        blackOverlay!.backgroundColor = UIColor.blackColor()
        blackOverlay!.alpha = 0.3
        backgroundImageView.addSubview(self.blackOverlay!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
