//
//  PlayersDetailViewController.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class PlayersDetailViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var heightLabel: UILabel!
    @IBOutlet private weak var heightLabelValue: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var positionLabelValue: UILabel!
    @IBOutlet private weak var weightLabel: UILabel!
    @IBOutlet private weak var weightLabelValue: UILabel!
    @IBOutlet private weak var teamLabel: UILabel!
    @IBOutlet private weak var teamLabelValue: UILabel!
    
    @IBOutlet private weak var bottomConstraintContainerView: NSLayoutConstraint!
    
    @IBOutlet private weak var closeViewButton: UIButton!
    @IBAction private func closeView(_ sender: UIButton) {
        self.dismissView()
    }
    
    var player: Player? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomConstraintContainerView.constant = -(containerView.frame.height + 50)
        self.view.layoutIfNeeded()
        
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.containerView.layer.cornerRadius = 40.0
        
        self.nameLabel.font = UIFont.montserrat(with: 24, and: .bold)
        self.nameLabel.textColor = .black
        
        self.heightLabel.attributedText = NSAttributedString(
            string: "height".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 17, and: .bold),
                .foregroundColor : UIColor.black
            ])
        self.heightLabelValue.font = UIFont.montserrat(with: 17, and: .medium)
        self.heightLabelValue.textColor = .black
        
        self.positionLabel.attributedText = NSAttributedString(
            string: "position".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 17, and: .bold),
                .foregroundColor : UIColor.black
            ])
        self.positionLabelValue.font = UIFont.montserrat(with: 17, and: .medium)
        self.positionLabelValue.textColor = .black
        
        self.weightLabel.attributedText = NSAttributedString(
            string: "weight".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 17, and: .bold),
                .foregroundColor : UIColor.black
            ])
        self.weightLabelValue.font = UIFont.montserrat(with: 17, and: .medium)
        self.weightLabelValue.textColor = .black
        
        self.teamLabel.attributedText = NSAttributedString(
            string: "team".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 17, and: .bold),
                .foregroundColor : UIColor.black
            ])
        self.teamLabelValue.font = UIFont.montserrat(with: 17, and: .medium)
        self.teamLabelValue.textColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: { [weak self] in
            self?.bottomConstraintContainerView.constant = 0
            self?.view.layoutIfNeeded()
        }, completion: nil)
        
        guard let player = player else { return }
        
        self.nameLabel.text = (player.first_name ?? "") + " " + (player.last_name ?? "")
        
        if let heightFeets = player.height_feet {
            if let heightInches = player.height_inches {
                self.heightLabelValue.text = "\(Int(heightFeets))ft \(Int(heightInches))in"
            }
        } else { self.heightLabelValue.text = "N/A" }
        
        if let position = player.position, position != "" {
            self.positionLabelValue.text = position
        } else {
            self.positionLabelValue.text = "N/A"
        }
        
        if let weight = player.weight_pounds {
            self.weightLabelValue.text = "\(Int(weight)) pounds"
        } else {
            self.weightLabelValue.text = "N/A"
        }
        
        self.teamLabelValue.text = player.team?.full_name ?? "N/A"
    }
    
    private func dismissView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.bottomConstraintContainerView.constant = -((self?.containerView.frame.height ?? 0.0) + 50)
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
    }

    deinit {
        self.closeViewButton = nil
    }
}
