//
//  RostersViewController.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class RostersViewController: UIViewController {
    
    @IBOutlet private weak var teamLogoImageView: UIImageView!
    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var cityValueLabel: UILabel!
    @IBOutlet private weak var conferenceLabel: UILabel!
    @IBOutlet private weak var conferenceValueLabel: UILabel!
    @IBOutlet private weak var divisionLabel: UILabel!
    @IBOutlet private weak var divisionValueLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var shadowView: UIView!
    
    @IBOutlet private weak var errorIncompleteBanner: UIView!
    @IBOutlet private weak var errorIncompleteLogo: UIImageView!
    @IBOutlet private weak var errorIncompletePlayersTitleLabel: UILabel!
    @IBOutlet private weak var errorIncompletePlayerBodyLabel: UILabel!
    @IBOutlet private weak var topErrorBannerConstraint: NSLayoutConstraint!
    
    private let api = AppDelegate.api
    
    var team: Team? = nil {
        didSet {
            self.fetchPlayers()
        }
    }
    
    private var players: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.api.delegate = self
        
        if api.allPlayersLoaded {
            self.errorIncompleteBanner.removeFromSuperview()
        } else {
            self.topErrorBannerConstraint.constant = -(self.errorIncompleteBanner.frame.height) - (self.navigationController?.navigationBar.frame.height ?? 40) - (self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 40.0)
            self.errorIncompleteBanner.backgroundColor = .systemRed
        }
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.montserrat(with: 17, and: .bold)]
        self.title = "rosters".localizeMe()
        
        self.shadowView.backgroundColor = .white
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.shadowView.layer.shadowRadius = 1.0
        self.shadowView.layer.shadowOpacity = 0.3
        
        self.tableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "player")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 40.0, right: 0.0)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        
        self.teamLogoImageView.contentMode = .scaleAspectFit
        
        self.teamNameLabel.font = UIFont.montserrat(with: 24, and: .black)
        self.teamNameLabel.textColor = .black
        
        self.errorIncompletePlayersTitleLabel.attributedText = NSAttributedString(
            string: "warning".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 17, and: .bold),
                .foregroundColor : UIColor.white
            ])
        self.errorIncompletePlayerBodyLabel.attributedText = NSAttributedString(
            string: "warning_body".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 15, and: .regular),
                .foregroundColor : UIColor.white
            ])
        self.errorIncompletePlayerBodyLabel.numberOfLines = 0
        
        self.cityLabel.attributedText = NSAttributedString(
            string: "city".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 15, and: .regular),
                .foregroundColor : UIColor.black
            ])
        self.cityValueLabel.font = UIFont.montserrat(with: 17, and: .medium)
        self.cityValueLabel.textColor = .black
        
        self.conferenceLabel.attributedText = NSAttributedString(
            string: "conference".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 15, and: .regular),
                .foregroundColor : UIColor.black
            ])
        self.conferenceValueLabel.font = UIFont.montserrat(with: 17, and: .medium)
        self.conferenceValueLabel.textColor = .black
        
        self.divisionLabel.attributedText = NSAttributedString(
            string: "division".localizeMe(),
            attributes: [
                .font : UIFont.montserrat(with: 15, and: .regular),
                .foregroundColor : UIColor.black
            ])
        self.divisionValueLabel.font = UIFont.montserrat(with: 17, and: .medium)
        self.divisionValueLabel.textColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let team = team else { return }
        
        api.getTeamLogo(abbreviation: team.abbreviation ?? "") { [weak self] image in
            DispatchQueue.inUIThread { [weak self] in
                self?.teamLogoImageView.image = image
            }
        }
        
        self.teamNameLabel.text = team.full_name
        self.cityValueLabel.text = team.city
        self.conferenceValueLabel.text = team.conference
        self.divisionValueLabel.text = team.division
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !api.allPlayersLoaded else { return }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .allowUserInteraction) { [weak self] in
            self?.topErrorBannerConstraint.constant = 0.0
            self?.view.layoutIfNeeded()
        } completion: { _ in}
    }
    
    
    private func fetchPlayers() {
        guard let team = team else { return }
        self.players = Array(Set(api.allPlayersArray.filter {$0.team == team})).sorted(by: {$0.last_name ?? "" < $1.last_name ?? ""})
    }
    
    deinit {
        self.teamLogoImageView = nil
        self.errorIncompleteLogo = nil
    }
    
}

extension RostersViewController: CanRemoveCustomLoadingDelegate {
    
    func removeCustomLoading() {
        
        DispatchQueue.inUIThread { [weak self] in
            guard topErrorBannerConstraint.constant == 0.0 else {
                self?.errorIncompleteBanner.removeFromSuperview()
                return
            }
            
            self?.errorIncompletePlayersTitleLabel.text = "completeLoading".localizeMe()
            self?.errorIncompletePlayerBodyLabel.text = "completeLoadingBody".localizeMe()
            self?.errorIncompleteBanner.backgroundColor = .systemGreen
            self?.errorIncompleteLogo.image = UIImage(systemName: "checkmark.seal.fill")
            
            self?.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 1.0, delay: 2.0, options: .allowUserInteraction) { [weak self] in
                let heightBanner = (self?.errorIncompleteBanner.frame.height ?? 0.0)
                let navBarHeight =  (self?.navigationController?.navigationBar.frame.height ?? 40)
                let statusBarHeight = (self?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 40.0)
                
                self?.topErrorBannerConstraint.constant = -heightBanner - navBarHeight - statusBarHeight
                
                self?.view.layoutIfNeeded()
                self?.fetchPlayers()
                self?.tableView.reloadData()
            } completion: { [weak self] _ in
                self?.errorIncompleteBanner.removeFromSuperview()
            }
        }
        
    }

}

extension RostersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let playerCell = tableView.dequeueReusableCell(withIdentifier: "player") as? PlayerTableViewCell else { return .init() }
        playerCell.setCell(player: self.players[indexPath.row])
        return playerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let playerDetail = self.storyboard?.instantiateViewController(withIdentifier: "playerDetail") as? PlayersDetailViewController else { return }
        playerDetail.player = self.players[indexPath.row]
        playerDetail.modalPresentationStyle = .overFullScreen
        playerDetail.modalTransitionStyle = .crossDissolve
        self.present(playerDetail, animated: true, completion: nil)
    }
    
}
