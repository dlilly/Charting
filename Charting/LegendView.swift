//
//  LegendView.swift
//  Charting
//
//  Created by Dave Lilly on 5/22/15.
//  Copyright (c) 2015 Dave Lilly. All rights reserved.
//

import UIKit

class LegendView: UIView {
    var data: [ColoredDataPoint]!
    
    override func drawRect(rect: CGRect) {
        // how tall do i need to be?  30px for every data point plus 20px on top and bottom for buffer
        var legendHeight: CGFloat = CGFloat(data.count * 30 + 40)
        var legendWidth: CGFloat = rect.size.width
        
        var legendFrameTopLeft: CGPoint = CGPointMake((rect.size.width - legendWidth) / 2.0, (rect.size.height - legendHeight) / 2.0)
        var legendFrameTopRight: CGPoint = CGPointMake(legendFrameTopLeft.x + legendWidth, legendFrameTopLeft.y)
        var legendFrameBottomRight: CGPoint = CGPointMake(legendFrameTopLeft.x + legendWidth, legendFrameTopLeft.y + legendHeight)
        var legendFrameBottomLeft: CGPoint = CGPointMake(legendFrameTopLeft.x, legendFrameTopLeft.y + legendHeight)

        drawLine(legendFrameTopLeft, end: legendFrameTopRight)
        drawLine(legendFrameTopRight, end: legendFrameBottomRight)
        drawLine(legendFrameBottomRight, end: legendFrameBottomLeft)
        drawLine(legendFrameBottomLeft, end: legendFrameTopLeft)
        
        // draw each data point
        for (index, datum) in enumerate(data) {
            var dpTop = legendFrameTopLeft.y + 20.0 + 30.0 * CGFloat(index)
            var dpRect: CGRect = CGRectMake(5.0, dpTop, legendWidth - 10, 30.0)
            var dataLabel: UILabel = UILabel(frame: CGRectMake(30, dpRect.origin.y, dpRect.size.width - 15, dpRect.size.height))
            var colorView: UIView = UIView(frame: CGRectMake(5.0, dpRect.origin.y + 5.0, 20.0, 20.0))
            
            dataLabel.font = UIFont.systemFontOfSize(13.0)
            dataLabel.text = datum.data.name
            addSubview(dataLabel)

            colorView.backgroundColor = datum.color
            addSubview(colorView)
        }
    }

    func drawLine(start: CGPoint, end: CGPoint, color: UIColor = UIColor.blackColor()) {
        var path = UIBezierPath()
        path.moveToPoint(start)
        path.addLineToPoint(end)
        
        color.setStroke()
        path.stroke()
    }
}
