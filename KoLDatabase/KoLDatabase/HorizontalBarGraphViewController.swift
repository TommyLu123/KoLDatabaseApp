//
//  HorizontalBarGraphViewController.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 5/1/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit
import Charts

// MARK: axisFormatDelegate
// https://github.com/danielgindi/Charts/issues/1527
// Adjusts data to allow for strings by mapping numbers to zones instead of just doubles
class ChartStringFormatter: NSObject, IAxisValueFormatter {
    
    var nameValues: [String]?
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return String(describing: nameValues![Int(value)])
    }
}

class HorizontalBarGraphViewController: UIViewController {

    @IBOutlet weak var horizontalBarGraph: HorizontalBarChartView!
    @IBOutlet weak var titleLabel: UILabel!
    var graphTitle: String?
    var parserModel: ParserModel?
    //Area or Level for turns spent
    var type: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = graphTitle
        
        // Do any additional setup after loading the view.
        
        horizontalBarGraph.drawBarShadowEnabled = false
        horizontalBarGraph.drawValueAboveBarEnabled = true
        
        horizontalBarGraph.maxVisibleCount = 60
        
        let xAxis = horizontalBarGraph.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 7)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 1
        xAxis.labelCount = 50
        
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
        self.updateChartWithData()
        
    }
    
    func updateChartWithData(){
        if type == "Area"{
            var dataEntries: [BarChartDataEntry] = []
            var nameValues: [String] = []
            
            for (i, entry) in (parserModel?.turnsSpentPerArea)!.enumerated(){
                nameValues.append(String(entry.zone.prefix(15)))
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(entry.turnsSpent))
                dataEntries.append(dataEntry)
                NSLog("\(i), \(entry.zone), \(entry.turnsSpent)")
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Turn Count")
            let chartData = BarChartData(dataSet: chartDataSet)
            self.horizontalBarGraph.xAxis.valueFormatter = IndexAxisValueFormatter(values:nameValues)
            self.horizontalBarGraph.data = chartData
            
        }
        else if type == "Level"{
            var dataEntries: [BarChartDataEntry] = []
            
            for (_, entry) in (parserModel?.turnsSpentPerLevel)!.enumerated(){
                let dataEntry = BarChartDataEntry(x: Double(entry.level), y: Double(entry.turnsSpent))
                dataEntries.append(dataEntry)
            }
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Turn Count")
            let chartData = BarChartData(dataSet: chartDataSet)
            self.horizontalBarGraph.data = chartData
        }else{
            NSLog("Wrong type passed in. Should never occur")
        }
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
