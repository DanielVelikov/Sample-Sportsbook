//
//  Button+Helper.swift
//  SampleApp
//
//  Created by Daniel Velikov on 17.02.24.
//

import UIKit

extension UIButton {
    func setTitle(_ text: String) {
        states.forEach { setTitle(text, for: $0) }
    }
    
    func setBackgroundImage(_ image: UIImage?) {
        states.forEach { setBackgroundImage(image, for: $0) }
    }
    
    func setImage(_ image: UIImage?) {
        states.forEach { setImage(image, for: $0) }
    }
}

extension UIControl {
    var states: [UIControl.State] { [.normal, .disabled, .selected, .focused, .highlighted] }
}
