//
//  Extensions.swift
//  Nasa
//
//  Created by Tomas Radvansky on 02/03/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Int {
    var weightStyle: String {
        if self == 0
        {
            return "?g"
        }
        else
        {
            if self > 1000000
            {
                return "\((Double(self) / 100000.0).roundTo(places: 2))t"
            }
            if self > 1000
            {
                return "\((Double(self) / 1000.0).roundTo(places: 2))kg"
            }
            else
            {
                return "\(self)g"
            }
        }
    }
}

protocol StringProtocol {
    var asString: String { get }
}

extension StringProtocol {
    var asString: String { return self as! String }
}

extension String: StringProtocol { }

extension Optional where Wrapped : StringProtocol {
    
    var safeValue: String {
        if case let .some(value) = self {
            return value.asString
        }
        return ""
    }
}

extension String
{
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return substring(from: fromIndex)
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return substring(to: toIndex)
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}
