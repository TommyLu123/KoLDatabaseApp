//
//  PieGraphViewController.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 5/1/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit
import Charts

class PieGraphViewController: UIViewController {

    @IBOutlet weak var pieGraph: PieChartView!
    var parserModel: ParserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let l = pieGraph.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        // entry label styling
        pieGraph.entryLabelColor = .white
        pieGraph.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        pieGraph.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        self.updateChartWithData()
    }
    
    func updateChartWithData(){
        var drinking = Double((parserModel?.turnGains.drinking)!)
        var eating = Double((parserModel?.turnGains.eating)!)
        var using = Double((parserModel?.turnGains.using)!)
        var rollover = Double((parserModel?.turnGains.rollover)!)
        
        let total = drinking + eating + using + rollover
        
        drinking = (drinking / total) * 100
        eating = (eating / total) * 100
        using = (using / total) * 100
        rollover = (rollover / total) * 100
        
        let drinkingEntry = PieChartDataEntry(value: drinking, label: "Drinking")
        let eatingEntry = PieChartDataEntry(value: eating, label: "Eating")
        let usingEntry = PieChartDataEntry(value: using, label: "Using")
        let rolloverEntry = PieChartDataEntry(value: rollover, label: "Rollover")
        
        let entries = [drinkingEntry, eatingEntry, usingEntry, rolloverEntry]
        let set = PieChartDataSet(values: entries, label: "Turn Gain Sources")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        self.pieGraph.data = data
        self.pieGraph.highlightValues(nil)
    }

    @IBAction func dismissPieGraphViewController(_ sender: Any) {
        dismiss(animated: false) {
            self.tabBarController?.viewControllers?.forEach { let _ = $0.view }
            
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

}
