//
//  TimelineCollectionViewCell.swift
//  RankingApp
//
//  Created by 小野翼 on 2020/03/13.
//  Copyright © 2020 TsubasaOno. All rights reserved.
//

import UIKit

class TimelineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var questionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.2
         //cellの枠の色
         self.layer.borderColor = UIColor.black.cgColor
         //cellを丸くする
        self.layer.cornerRadius = 4.0
        
        questionLabel.lineBreakMode = .byWordWrapping
        
    }

}
