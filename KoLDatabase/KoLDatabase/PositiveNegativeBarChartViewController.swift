//
//  PositiveNegativeBarChartViewController.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 5/2/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit
import Charts

class PositiveNegativeBarChartViewController: UIViewController {
    
    @IBOutlet weak var positiveNegativeBarChart: BarChartView!
    var parserModel: ParserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        positiveNegativeBarChart.setExtraOffsets(left: 70, top: -30, right: 70, bottom: 10)
        
        positiveNegativeBarChart.drawBarShadowEnabled = false
        positiveNegativeBarChart.drawValueAboveBarEnabled = true
        
        positiveNegativeBarChart.chartDescription?.enabled = false
        
        positiveNegativeBarChart.rightAxis.enabled = false
        
        let xAxis = positiveNegativeBarChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 13)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = 5
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 1
        
        let leftAxis = positiveNegativeBarChart.leftAxis
        leftAxis.drawLabelsEnabled = false
        leftAxis.spaceTop = 0.25
        leftAxis.spaceBottom = 0.25
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawZeroLineEnabled = true
        leftAxis.zeroLineColor = .gray
        leftAxis.zeroLineWidth = 0.7
        
        self.updateChartWithData()
        // Do any additional setup after loading the view.
    }
    
    func updateChartWithData(){
        var entries: [BarChartDataEntry] = []
        for entry in (self.parserModel?.meatNet)!{
            let newEntry = BarChartDataEntry(x: Double(entry.level), y: Double(entry.meatGained - entry.meatSpent))
            entries.append(newEntry)
        }
        
        
        let red = UIColor(red: 211/255, green: 74/255, blue: 88/255, alpha: 1)
        let green = UIColor(red: 110/255, green: 190/255, blue: 102/255, alpha: 1)
        let colors = entries.map { (entry) -> NSUIColor in
            return entry.y > 0 ? green : red
        }
        
        let set = BarChartDataSet(values: entries, label: "Values")
        set.colors = colors
        set.valueColors = colors
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 13))
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.barWidth = 0.8
        
        positiveNegativeBarChart.data = data
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dismissPositiveNegativeBarChartViewController(_ sender: Any) {
        dismiss(animated: false) {
            self.tabBarController?.viewControllers?.forEach { let _ = $0.view }
            
        }
    }
    
}
