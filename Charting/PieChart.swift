//
//  PieChart.swift
//  Charting
//
//  Created by Dave Lilly on 5/21/15.
//  Copyright (c) 2015 Dave Lilly. All rights reserved.
//

import UIKit

let PI: CGFloat = 3.14
let kRadian: CGFloat = PI / 180

typealias DataPoint = (name: String, value: CGFloat)
typealias ColoredDataPoint = (data: DataPoint, color: UIColor)

class PieChart: UIView {
    var data: [DataPoint]!
    var chartView: UIView!
    var legendView: LegendView!
    var colors: [UIColor]! = nil
    var baseColor: UIColor = UIColor.redColor()
    
    override func drawRect(rect: CGRect) {
        if colors == nil {
            colors = [UIColor]()
            colors.append(baseColor)

            var redValue: CGFloat = 0.0
            var greenValue: CGFloat = 0.0
            var blueValue: CGFloat = 0.0
            var alphaValue: CGFloat = 0.0
            
            baseColor.getRed(&redValue, green: &greenValue, blue: &blueValue, alpha: &alphaValue)
            colors.append(UIColor(red: greenValue, green: blueValue, blue: redValue, alpha: alphaValue))
            colors.append(UIColor(red: blueValue, green: redValue, blue: greenValue, alpha: alphaValue))
            
            // secondary
            colors.append(UIColor(red: 1 - redValue, green: 1 - greenValue, blue: 1 - blueValue, alpha: alphaValue))
            colors.append(UIColor(red: 1 - greenValue, green: 1 - blueValue, blue: 1 - redValue, alpha: alphaValue))
            colors.append(UIColor(red: 1 - blueValue, green: 1 - redValue, blue: 1 - greenValue, alpha: alphaValue))
        }
        
        var total: CGFloat = data.reduce(0, combine: { $0 + $1.value })

        // set up the subviews (chart and legend)
        chartView = UIView(frame: CGRectMake(0, 0, frame.size.width * 0.75, frame.size.height))
        legendView = LegendView(frame: CGRectMake(frame.size.width * 0.75, 0, frame.size.width * 0.24, frame.size.height))
        legendView.backgroundColor = UIColor.whiteColor()
        
        addSubview(chartView)
        addSubview(legendView)

        // set up two areas: one for the chart, and one for the legend
        var chartRect = chartView.frame
        
        var coloredData: [ColoredDataPoint] = [ColoredDataPoint]()
        var subtotal: CGFloat = 0
        for (index, datum) in enumerate(data) {
            var color = colors[index % colors.count]
            drawSlice(chartRect, degrees: datum.value / total * 360, startPos: subtotal, color: color)
            coloredData.append(ColoredDataPoint(data: datum, color: color))
            subtotal += datum.value / total * 360
        }

        legendView.data = coloredData
    }

    func drawSlice(rect: CGRect, degrees: CGFloat, startPos: CGFloat, color: UIColor) {
        var path = UIBezierPath()
        var short: CGFloat = rect.width < rect.height ? rect.width : rect.height
        var diameter: CGFloat = short * 0.9
        var radius: CGFloat = diameter / 2
        var center: CGPoint = CGPointMake(rect.width / 2, rect.height / 2)
        path.moveToPoint(center)
        path.addArcWithCenter(center, radius: radius, startAngle: kRadian * startPos, endAngle: kRadian * (degrees + startPos), clockwise: true)
        color.setFill()
        path.fill()
    }
}
