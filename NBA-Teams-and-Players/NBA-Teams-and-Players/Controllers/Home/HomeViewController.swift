//
//  HomeViewController.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class HomeViewController: UITableViewController {
    
    private let api = AppDelegate.api
    
    private var teams: [Team]? = nil {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "TeamsTableViewCell", bundle: nil), forCellReuseIdentifier: "team")
        self.tableView.register(UINib(nibName: "TeamsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        self.tableView.contentInset.bottom = 40
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.montserrat(with: 30, and: .black)]
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.montserrat(with: 17, and: .bold)]
        self.title = "teams".localizeMe()
        
        let button = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(showOnBoarding))
        button.tintColor = .black
        self.navigationItem.rightBarButtonItem = button
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(getAllTeams), for: .valueChanged)
        self.tableView.refreshControl = refresh
        
        self.displayCustomActivityIndicatorAlert(completion: { [weak self] in
            self?.getAllTeams()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let teams = self.teams, !teams.isEmpty else { return }
        self.tableView.reloadData()
    }
    
    @objc private func getAllTeams() {
        self.tableView.isUserInteractionEnabled = false
        self.api.getAllTeams(page: 0) { [weak self] teams in
            self?.dismissCustomActivityIndicatorAlert(completion: { [weak self] in
                self?.teams = teams.data?.sorted(by: {($0.full_name ?? "") < ($1.full_name ?? "")})
                self?.tableView.smoothEndRefreshing()
                self?.tableView.isUserInteractionEnabled = true
            })
        } failure: { [weak self] error in
            self?.dismissCustomActivityIndicatorAlert(completion: { [weak self] in
                self?.setSimpleAlert(title: "Error", message: error.message)
                self?.teams = nil
                self?.tableView.smoothEndRefreshing()
                self?.tableView.isUserInteractionEnabled = true
            })
        }
    }
    
    @objc private func showOnBoarding() {
        guard let onBoarding = self.storyboard?.instantiateViewController(withIdentifier: "onboarding") as? OnBoardingContainerViewController else { return }
        self.present(onBoarding, animated: true, completion: nil)
    }
    
    //MARK: UITableView delegates
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? TeamsHeader
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teams?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let teamCell = tableView.dequeueReusableCell(withIdentifier: "team") as? TeamsTableViewCell else {return .init()}
        guard let teams = self.teams else {return .init()}
        
        teamCell.setCell(team: teams[indexPath.row])
        return teamCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let rostersVC = self.storyboard?.instantiateViewController(withIdentifier: "rosters") as? RostersViewController
              else {return}
        rostersVC.team = self.teams?[indexPath.row]
        self.navigationController?.pushViewController(rostersVC, animated: true)
    }
    
}
