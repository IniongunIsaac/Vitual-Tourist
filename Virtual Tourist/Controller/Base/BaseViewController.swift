//
//  BaseViewController.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 21/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import UIKit
import Alertift
import ProgressHUD

class BaseViewController: UIViewController {
    
    func showLoading(loadingMessage: String) {
        ProgressHUD.spinnerColor(.appColor)
        ProgressHUD.statusColor(.appColor)
        ProgressHUD.show(loadingMessage, interaction: false)
    }
    
    func hideLoading() {
        ProgressHUD.dismiss()
    }
    
    func showAlert(with message: String, alertType: AlertType, dismissAction: (() -> Void)? = nil) {
        
        let alertImage: UIImage? = alertType == .success ? UIImage(named: "success") : UIImage(named: "error")

        Alertift.alert(message: message)
            .image(alertImage, imageTopMargin: .belowRoundCorner)
            .action(.cancel("Dismiss"))
            .finally({ action, index, textfield  in
                dismissAction?()
            })
            .show(on: self)
    }
    
    func showAlert(with message: String, alertType: AlertType, dismissText: String = "Dismiss", yesActionText: String = "Okay", yesAction: @escaping () -> Void, dismissAction: @escaping () -> Void) {
        
        let alertImage: UIImage? = alertType == .success ? UIImage(named: "success") : UIImage(named: "error")

        Alertift.alert(message: message)
            .image(alertImage, imageTopMargin: .belowRoundCorner)
            .action(.cancel(dismissText))
            .action(.default(yesActionText))
            .finally({ action, index, textfield  in
                if action.style == .cancel {
                    dismissAction()
                } else {
                    yesAction()
                }
            })
            .show(on: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
