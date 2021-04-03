//
//  PlayerTableViewCell.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.accessoryType = .detailButton
        self.accessoryView?.tintColor = .black
        
        self.positionLabel.font = UIFont.montserrat(with: 15, and: .black)
        self.nameLabel.font = UIFont.montserrat(with: 17, and: .regular)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.positionLabel.text = nil
        self.nameLabel.text = nil
    }
    
    deinit {
        self.accessoryView = nil
    }
    
    func setCell(player: Player) {
        if let position = player.position, position != "" {
            self.positionLabel.text = position
        } else {
            self.positionLabel.text = "N/A"
        }
        
        if (player.last_name ?? "") == "" {
            self.nameLabel.text = player.first_name
        } else if let firstLetter = player.first_name?.first {
            var name = String()
            name = firstLetter.uppercased() + ". "
            self.nameLabel.text = name + (player.last_name ?? "")
        }
        
    }
    
}
