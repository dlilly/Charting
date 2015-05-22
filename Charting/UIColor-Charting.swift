//
//  UIColor-Charting.swift
//  Charting
//
//  Created by Dave Lilly on 5/22/15.
//  Copyright (c) 2015 Dave Lilly. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var rH = hex[0...2]
        var gH = hex[2...4]
        var bH = hex[4...6]
        self.init(red: CGFloat(rH.hexToInt)/255.0, green: CGFloat(gH.hexToInt)/255.0, blue: CGFloat(bH.hexToInt)/255.0, alpha: 1.0)
    }
}

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(self.startIndex, r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    var hexToInt: Int {
        return strtol(self, nil, 16)
    }
}