//
//  CustomBackButton.swift
//  Taboo
//
//  Created by Chris Lucas on 25.10.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation
import UIKit

func getCustomBackButton(title: String) -> UIButton {
    let backButton = UIButton(type: .system)
    backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)), for: .normal)
    backButton.setTitle(title, for: .normal)
    backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    backButton.setTitleColor(backButton.tintColor, for: .normal)
    backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0)
    backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
    return backButton
}
