//
//  TeamsTableViewCell.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class TeamsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var logoTeam: UIImageView!
    @IBOutlet private weak var nameTeam: UILabel!
    
    private var team: Team? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.logoTeam.contentMode = .scaleAspectFit
        self.logoTeam.image = UIImage(named: "placeholder")
        
        self.nameTeam.numberOfLines = 2
        self.nameTeam.font = UIFont.montserrat(with: 22, and: .bold)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.logoTeam.image = UIImage(named: "placeholder")
        self.nameTeam.text = nil
    }
    
    func setCell(team: Team) {
        self.team = team
        
        self.nameTeam.text = (team.city ?? "N/A") + "\n" + (team.name ?? "N/A")
        
        guard let abbreviation = team.abbreviation else {
            self.logoTeam.image = UIImage(named: "placeholder")
            return
        }
        
        APIManager.shared.getTeamLogo(abbreviation: abbreviation) { [weak self] image in
            DispatchQueue.inUIThread { [weak self] in
                if let image = image, team == self?.team {
                    self?.logoTeam.image = image
                } else {
                    self?.logoTeam.image = UIImage(named: "placeholder")
                }
            }
            
        }
        
    }
    
}
