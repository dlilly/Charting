//
//  ChartUtils.swift
//  Charting
//
//  Created by Dave Lilly on 5/26/15.
//  Copyright (c) 2015 Dave Lilly. All rights reserved.
//

import UIKit

class ChartUtils: NSObject {
   
}

func findMax(data: [DataPoint]!) -> CGFloat {
    var maxValue: CGFloat = 0
    for datum in data {
        if datum.value > maxValue {
            maxValue = datum.value
        }
    }
    return maxValue
}

extension CGRect {
    func horizontalCenteredRect(size: CGSize) -> CGRect {
        return CGRectMake((self.size.width - size.width) / 2, 0, size.width, size.height)
    }

    func verticalCenteredRect(size: CGSize) -> CGRect {
        return CGRectMake(0, (self.size.height - size.height) / 2, size.width, size.height)
    }

    func centeredRect(size: CGSize) -> CGRect {
        return CGRectMake((self.size.width - size.width) / 2, (self.size.height - size.height) / 2, size.width, size.height)
    }
}

extension UIView {
    func showBorders() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.blackColor().CGColor
    }
}