//
//  OnBoardingPageViewController.swift
//  NBA-Teams-and-Players
//
//  Created by Elia Crocetta on 02/04/21.
//

import UIKit

protocol MoveDots {
    func set(index: Int)
}

class OnBoardingPageViewController: UIPageViewController {
    
    private lazy var VCArray: [UIViewController] = {
        guard let firstVC =  OnBoardingViewController.instanceVc(index: 0) else {return []}
        guard let secondVC = OnBoardingViewController.instanceVc(index: 1) else {return []}
        guard let thirdVC =  OnBoardingViewController.instanceVc(index: 2) else {return []}
        return [firstVC, secondVC, thirdVC]
    }()
    
    var moveDotsDelegate: MoveDots? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        self.view.backgroundColor = .white
        
        guard let first = self.VCArray.first else { return }
        self.setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }

}

extension OnBoardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.first as? OnBoardingViewController else { return }
        
        let vcIndex = vc.getIndex
        self.moveDotsDelegate?.set(index:vcIndex)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnBoardingViewController, let viewControllerIndex = VCArray.firstIndex(of: vc) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        guard VCArray.count > previousIndex else { return nil }
        
        return VCArray[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnBoardingViewController, let viewControllerIndex = VCArray.firstIndex(of: vc) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArray.count else { return nil }
        guard VCArray.count > nextIndex else { return nil }
        
        return VCArray[nextIndex]
    }
    
}
