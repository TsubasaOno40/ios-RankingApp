//
//  UserVoteCollectionViewCell.swift
//  RankingApp
//
//  Created by 小野翼 on 2020/05/01.
//  Copyright © 2020 TsubasaOno. All rights reserved.
//

import UIKit

class UserVoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var userVoteNamelabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 0.2
        //cellの枠の色
        self.layer.borderColor = UIColor.black.cgColor
        //cellを丸くする
        self.layer.cornerRadius = 4.0
    }
    

}
