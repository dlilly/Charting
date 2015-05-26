//
//  ViewController.swift
//  Charting
//
//  Created by Dave Lilly on 5/21/15.
//  Copyright (c) 2015 Dave Lilly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        var data = [DataPoint]()
        data.append(DataPoint(name: "Electronics", value: 58))
        data.append(DataPoint(name: "Bakeware", value: 22))
        data.append(DataPoint(name: "Pots and Pans", value: 13))
        data.append(DataPoint(name: "Cutlery", value: 74))
        
        var chart: ChartView = BarChart()
        chart.frame = CGRectMake(200, 200, 400, 400)
        view.addSubview(chart)
        chart.data = data

        // taken from http://www.mulinblog.com/a-color-palette-optimized-for-data-visualization/
        chart.colors = [
            UIColor(hex: "4D4D4D"),
            UIColor(hex: "5DA5DA"),
            UIColor(hex: "FAA43A"),
            UIColor(hex: "60BD68"),
            UIColor(hex: "F17CB0"),
            UIColor(hex: "B2912F"),
            UIColor(hex: "B276B2"),
            UIColor(hex: "DECF3F"),
            UIColor(hex: "F15854"),
        ]
    }
}

