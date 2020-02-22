//
//  View+Extensions.swift
//  Virtual Tourist
//
//  Created by Isaac Iniongun on 21/02/2020.
//  Copyright © 2020 Iniongun Group. All rights reserved.
//

import Foundation
import UIKit

//MARK: - UIView Inspectables
extension UIView {
    
    func addTapGesture(action: @escaping () -> Void ){
        let tap = UIViewTapGestureRecognizer(target: self , action: #selector(self.handleTap(_:)))
        tap.action = action
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        
    }
    @objc func handleTap(_ sender: UIViewTapGestureRecognizer) {
        sender.action!()
    }
    
}

//MARK: - Custom UIViewTapGestureRecognizer
class UIViewTapGestureRecognizer: UITapGestureRecognizer {
    var action : (()->Void)? = nil
}

extension UICollectionView {

    func setNoValuesFoundBackgroundMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Avenir-Light", size: 13)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func removeBackgroundView() {
        self.backgroundView = nil
    }
}
