//
//  HorizontalBarGraphViewController.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 5/1/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit
import Charts

class HorizontalBarGraphViewController: UIViewController {

    @IBOutlet weak var horizontalBarGraph: HorizontalBarChartView!
    
    var graphTitle: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        horizontalBarGraph.drawBarShadowEnabled = false
        horizontalBarGraph.drawValueAboveBarEnabled = true
        
        horizontalBarGraph.maxVisibleCount = 60
        
        let xAxis = horizontalBarGraph.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 10
        
        let leftAxis = horizontalBarGraph.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        
        let rightAxis = horizontalBarGraph.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0
        
        let l = horizontalBarGraph.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        //        chartView.legend = l
        
        horizontalBarGraph.fitBars = true
        
        horizontalBarGraph.animate(yAxisDuration: 2.5)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismissHorizontalBarGraphViewController(_ sender: Any) {
        dismiss(animated: false) {
            self.tabBarController?.viewControllers?.forEach { let _ = $0.view }
            
        }
    }
}
