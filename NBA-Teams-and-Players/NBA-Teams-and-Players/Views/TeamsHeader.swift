//
//  TeamsHeader.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class TeamsHeader: UITableViewHeaderFooterView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = .white
        
        self.titleLabel.attributedText = NSAttributedString(
            string: "select_team".localizeMe(),
            attributes: [
                NSAttributedString.Key.font : UIFont.montserrat(with: 20, and: .regular),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ])
    }
}
