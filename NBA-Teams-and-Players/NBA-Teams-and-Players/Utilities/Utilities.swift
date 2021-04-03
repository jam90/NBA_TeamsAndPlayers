//
//  Utilities.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import Foundation
import UIKit

//MARK: UIApplication
extension UIApplication {
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        guard var topController = keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    
}

//MARK: String
extension String {
    
    func localizeMe() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}

//MARK: UIView
extension UIView {
    func dropShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
    }
}

//MARK: DispatchQueue
extension DispatchQueue {
    
    static func inUIThread(_ action: (() -> Void)) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.sync {
                action()
            }
        }
    }
    
}

//MARK: UIViewController
extension UIViewController {
    
    func setSimpleAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayCustomActivityIndicatorAlert(completion: (() -> Void)?) {
        DispatchQueue.inUIThread {
            
            if let activityShown = UIApplication.topViewController() as? CustomLoadingViewController, activityShown.restorationIdentifier == "publicAC" {
                return
            }
            
            let activityIndicatorAlert = CustomLoadingViewController(nibName: "CustomLoadingViewController", bundle: nil)
            
            guard let topController = UIApplication.topViewController(), (topController as? UIAlertController == nil) else {return}
            topController.present(activityIndicatorAlert, animated: true, completion: completion)
        }
    }
        
    func dismissCustomActivityIndicatorAlert(completion: (() -> Void)?) {
        DispatchQueue.inUIThread {
            guard let topController = UIApplication.topViewController() else {completion?(); return}
            
            if let activityShown = topController as? CustomLoadingViewController, activityShown.restorationIdentifier == CustomLoadingViewController.restorationID {
                activityShown.dismiss(animated: true, completion: completion)
            } else {
                completion?()
            }
        }
        
    }
    
}

//MARK: UIAlertController
extension UIAlertController {
    
    private struct ActivityIndicatorData {
        static var activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    }
    
    func addActivityIndicator() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 40,height: 40)
        ActivityIndicatorData.activityIndicator.startAnimating()
        ActivityIndicatorData.activityIndicator.style = .large
        ActivityIndicatorData.activityIndicator.color = UIColor.gray
        vc.view.addSubview(ActivityIndicatorData.activityIndicator)
        self.setValue(vc, forKey: "contentViewController")
    }
    
    func dismissActivityIndicator(completion: (() -> Void)?) {
        self.dismiss(animated: true, completion: completion)
    }
}

//MARK: UITableView
extension UITableView {
    func smoothEndRefreshing() {
        self.refreshControl?.perform(#selector(self.refreshControl?.endRefreshing), with: nil, afterDelay: 0.05)
    }
}

//MARK: UIFont
extension UIFont {
    
    static func montserrat(with size: CGFloat, and weight: MontserratWeight) -> UIFont {
        let weightString = "\(weight)".capitalizingFirstLetter()
        guard let font = UIFont(name: "Montserrat-\(weightString)", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: UIFont.Weight.ultraLight)
        }
        return font
    }
    
    enum MontserratWeight {
        case black
        case light
        case bold
        case medium
        case regular
    }
    
}
