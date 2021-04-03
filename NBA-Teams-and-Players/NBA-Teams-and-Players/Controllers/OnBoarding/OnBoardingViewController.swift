//
//  OnBoardingViewController.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet private weak var imageAsset: UIImageView!
    @IBOutlet private weak var titlePage: UILabel!
    
    private var index: Int? = nil
    
    var getIndex: Int {
        get {
            return self.index ?? 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titlePage.font = UIFont.montserrat(with: 18, and: .medium)
        self.titlePage.numberOfLines = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let index = self.index else {return}
        
        if let firstLang = Locale.preferredLanguages.first, firstLang.contains("it-") {
            if index < 3 {
                let image = UIImage(named: "onboarding_ita\(index+1)")
                self.imageAsset.image = image
            }
        } else {
            if index < 3 {
                let image = UIImage(named: "onboarding_\(index+1)")
                self.imageAsset.image = image
            }
        }
        
        self.titlePage.text = "onBoarding\(index)".localizeMe()
    }
    
    class func instanceVc(index: Int) -> OnBoardingViewController? {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "content") as? OnBoardingViewController else {return nil}
        vc.index = index
        return vc
    }

}
