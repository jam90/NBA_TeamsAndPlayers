//
//  OnBoardingContainerViewController.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class OnBoardingContainerViewController: UIViewController, MoveDots {
    
    @IBOutlet private weak var containerPageVC: UIView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    @IBOutlet private weak var mainButtonOutlet: UIButton!
    @IBAction private func mainButtonAction(_ sender: UIButton) {
        
        if let isSkipped = UserDefaultsManager.shared.getValue(for: .skipOnBoarding) as? Bool, isSkipped {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        guard let home = self.storyboard?.instantiateViewController(withIdentifier: "home") as? UINavigationController else {return}
        home.modalPresentationStyle = .fullScreen
        self.present(home, animated: true) {
            UserDefaultsManager.shared.setValue(true, for: .skipOnBoarding)
        }
    }
    
    @IBOutlet private weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainButtonOutlet.layer.cornerRadius = 10
        self.mainButtonOutlet.alpha = 0.0
        self.mainButtonOutlet.dropShadow()
        
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        
        self.pageControl.currentPageIndicatorTintColor = .systemOrange
        self.pageControl.pageIndicatorTintColor = .gray
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.backgroundColor = .clear
        
        let buttonTitle = NSAttributedString(
            string: "start".localizeMe(),
            attributes: [
                NSAttributedString.Key.font : UIFont.montserrat(with: 20, and: .medium),
                NSAttributedString.Key.foregroundColor : UIColor.white
            ])
        
        self.mainButtonOutlet.setAttributedTitle(buttonTitle, for: .normal)
        self.mainButtonOutlet.backgroundColor = UIColor.systemBlue
        self.mainButtonOutlet.layer.cornerRadius = 8.0
        
        self.welcomeLabel.attributedText = NSAttributedString(
            string: "welcome".localizeMe(),
            attributes: [
                NSAttributedString.Key.font : UIFont.montserrat(with: 24, and: .black),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ])
    }
    
    func set(index: Int) {
        self.pageControl.currentPage = index
        let isTheLastPage = (index == 2)
        
        UIView.animate(withDuration: 0.5) {
            self.mainButtonOutlet.alpha = isTheLastPage ? 1.0 : 0.0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue", let boarding = segue.destination as? OnBoardingPageViewController {
            boarding.moveDotsDelegate = self
        }
    }
    
}
