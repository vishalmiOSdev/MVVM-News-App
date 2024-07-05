//
//  Activity Indicator.swift
//  Quick App
//
//  Created by Vishal Manhas on 05/07/24.
//

import Foundation
import UIKit

struct ActivityIndicatorManager {
    static func showActivityIndicator() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                let activityIndicator = UIActivityIndicatorView(style: .large)
                activityIndicator.center = window.center
                activityIndicator.tag = 999 // Arbitrary tag to identify the indicator later
                window.addSubview(activityIndicator)
                activityIndicator.startAnimating()
            }
        }
    }

    static func hideActivityIndicator() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
               let activityIndicator = window.viewWithTag(999) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
