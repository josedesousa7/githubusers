//
//  UIViewController + AlertViewController.swift
//  githubusers
//
//  Created by José Marques on 20/04/2021.
//  Copyright © 2021 José Marques. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    internal func presentAlertController(withTitle title: String, andMessage message: String) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_alert_button", comment: ""), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel_alert_button", comment: ""), style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
}
