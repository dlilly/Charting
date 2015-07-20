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
let lineHeight: CGFloat = 30

public class DataPoint {
    var name: String!
    var value: CGFloat!
    var color: UIColor!

    public init(name: String!, value: CGFloat!, color: UIColor? = nil) {
        self.name = name
        self.value = value
        self.color = color
    }
}

public class ChartView: UIView {
    public var data: [DataPoint]!

    var chartView: UIView!
    var legendView: LegendView!
    
    public var colors: [UIColor]! = nil { didSet { baseColor = colors[0] } }
    public var baseColor: UIColor = UIColor.redColor()

    override public func drawRect(rect: CGRect) {
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
    }
}

public class PieChart: ChartView {
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)

        var total: CGFloat = data.reduce(0, combine: { $0 + $1.value })

        // set up the subviews (chart and legend)
        chartView = UIView(frame: CGRectMake(0, 0, frame.size.width * 0.75, frame.size.height))
        chartView.backgroundColor = UIColor.clearColor()
        legendView = LegendView(frame: CGRectMake(frame.size.width * 0.75, frame.origin.y, frame.size.width * 0.24, frame.size.height))
        legendView.backgroundColor = UIColor.whiteColor()
        
        addSubview(chartView)
        addSubview(legendView)

        // set up two areas: one for the chart, and one for the legend
        var chartRect = chartView.frame
        
        let bg = UIBezierPath(rect: chartRect)
        UIColor.whiteColor().setFill()
        bg.fill()
        
        var subtotal: CGFloat = 0
        for (index, datum) in enumerate(data) {
            var color = colors[index % colors.count]
            drawSlice(chartRect, degrees: datum.value / total * 360, startPos: subtotal, color: color)
            datum.color = color
            subtotal += datum.value / total * 360
        }

        legendView.data = data
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

public class BarChart: ChartView {
    public var dataLabelFormatter: (CGFloat) -> String = { "\($0)" }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // no legend for bar chart as the data labels are displayed next to the data
        chartView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        chartView.backgroundColor = UIColor.whiteColor()
        addSubview(chartView)
        
        var numberOfDataPoints: Int = min(data.count, Int(rect.height) / Int(lineHeight))
        
        var chartHeight = CGFloat(numberOfDataPoints) * (lineHeight + 5)
        
        var chartRect = chartView.frame.centeredRect(CGSizeMake(chartView.frame.width - 10, chartHeight))
        var cv = UIView(frame: chartRect)
        
        chartView.addSubview(cv)
        
        data.sort({ $0.value > $1.value })
        
        var maxValue = findMax(data)
        for var i: Int = 0; i < numberOfDataPoints; i++ {
            var datum = data[i]

            var dataView = UIView(frame: CGRectMake(0, CGFloat(i) * (lineHeight + 5), cv.frame.size.width, lineHeight))
            cv.addSubview(dataView)

            var label = UILabel(frame: CGRectMake(0, 0, dataView.frame.width * 0.4 - 10, dataView.frame.height))
            label.text = datum.name
            label.textAlignment = NSTextAlignment.Right
            
            dataView.addSubview(label)
            
            var barLength: CGFloat = datum.value / maxValue * cv.frame.size.width * 0.6
            var barContainer = UIView(frame: CGRectMake(dataView.frame.width * 0.4, 0, dataView.frame.width * 0.6, lineHeight))

            var valueLabel = UILabel(frame: CGRectMake(0, 0, barContainer.frame.size.width, barContainer.frame.size.height))
            valueLabel.text = dataLabelFormatter(datum.value)
            valueLabel.textAlignment = NSTextAlignment.Center
            valueLabel.font = UIFont.systemFontOfSize(12.0)

            var barView = UIView(frame: barContainer.frame.verticalCenteredRect(CGSizeMake(barLength, lineHeight - 5)))
            barView.backgroundColor = baseColor

            barContainer.addSubview(barView)
            barContainer.insertSubview(valueLabel, aboveSubview: barView)

            dataView.addSubview(barContainer)
        }
    }
}
