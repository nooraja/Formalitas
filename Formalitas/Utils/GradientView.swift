//
//  GradientView.swift
//  Formalitas
//
//  Created by NOOR on 18/03/20.
//  Copyright © 2020 NOOR. All rights reserved.
//

import UIKit

class GradientView: UIView {

    //MARK:- Public Method

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        let backgroundRect = bounds
        context?.drawLinearGradient(
            in: backgroundRect,
            startingWith: UIColor.blueFacebook.cgColor,
            finishingWith: UIColor.white.cgColor
        )
    }

    func changeGradientColor(firstColor: UIColor, secondColor: UIColor) {
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(in: bounds, startingWith: firstColor.cgColor, finishingWith: secondColor.cgColor)
    }
}



