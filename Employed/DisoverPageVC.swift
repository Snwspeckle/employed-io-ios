//
//  DiscoverPagVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/7/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit

class DiscoverPageVC: UIPageViewController {

	// Array of view controllers to populate the UIPageViewController
	private(set) var pageViewControllers: [UIViewController] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.dataSource = self
		
		self.pageViewControllers = [self.getViewControllerFromStoryboard("Blue"), self.getViewControllerFromStoryboard("Red")]
		
		if let firstViewController = self.pageViewControllers.first {
			setViewControllers([firstViewController],
				direction: .forward,
				animated: true,
				completion: nil)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	/**
	 Helper function to get a view controller from the Main storyboard
	 by appending the `name` parameter to `ViewController`.
	 */
    private func getViewControllerFromStoryboard(_ name: String) -> UIViewController {
    	return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"\(name)ViewController")
	}

}

// MARK: - UIPageViewControllerDataSource
extension DiscoverPageVC : UIPageViewControllerDataSource {

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = self.pageViewControllers.index(of: viewController) else {
			return nil
		}
		
		let previousIndex = viewControllerIndex - 1
		
		guard previousIndex >= 0 else {
			return nil
		}
		
		guard self.pageViewControllers.count > previousIndex else {
			return nil
		}
		
		return self.pageViewControllers[previousIndex]
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = self.pageViewControllers.index(of: viewController) else {
			return nil
		}
		
		let nextIndex = viewControllerIndex + 1
		
		guard self.pageViewControllers.count != nextIndex else {
			return nil
		}
		
		guard self.pageViewControllers.count > nextIndex else {
			return nil
		}
		
		return self.pageViewControllers[nextIndex]
	}
	
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return self.pageViewControllers.count
	}
	
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		guard let firstViewController = viewControllers?.first,
			let firstViewControllerIndex = self.pageViewControllers.index(of: firstViewController) else {
				return 0
		}
		
		return firstViewControllerIndex
	}
}
