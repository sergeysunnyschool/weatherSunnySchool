//
//  UIViewController+Extension.swift
//  Weather
//
//  Created by Local Express on 03.04.21.
//

import UIKit

extension UIViewController {
    
    func displayError(_ error: Error?) {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
