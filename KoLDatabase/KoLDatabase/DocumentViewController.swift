//
//  DocumentViewController.swift
//  KoLVisualizer
//
//  Created by Tommy Lu on 4/29/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit
import Charts

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var document: Document?
    var parserModel: ParserModel?
    
    @IBOutlet weak var logPlainText: UITextView!
    
    @IBOutlet weak var turnSpentByAreaButton: UIButton!
    @IBOutlet weak var turnSpentPerLevelButton: UIButton!
    @IBOutlet weak var turnGainBySourceButton: UIButton!
    @IBOutlet weak var meatNetByLevelButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                self.turnSpentByAreaButton.isEnabled = false
                self.turnSpentPerLevelButton.isEnabled = false
                self.turnGainBySourceButton.isEnabled = false
                self.meatNetByLevelButton.isEnabled = false
                
                // Display the content of the document, e.g.:
                self.logPlainText.text = self.document?.userText
                self.navigationBar.topItem?.title = self.document?.fileURL.lastPathComponent
                // If we return to this view and parserModel has been parsed, then we do not reparse
                if self.parserModel == nil {
                    if self.logPlainText.text.contains("[code]===Day 1==="){
                        //parse
                        self.parserModel = ParserModel(documentText: (self.document?.userText)!)
                        self.parserModel?.parse()
                        self.turnSpentByAreaButton.isEnabled = true
                        self.turnSpentPerLevelButton.isEnabled = true
                        self.turnGainBySourceButton.isEnabled = true
                        self.meatNetByLevelButton.isEnabled = true
                        //activate graph buttons on finish parse
                    }
                    else{
                        self.turnSpentByAreaButton.setTitle("Unable to load this log.", for: .normal)
                        self.turnSpentPerLevelButton.setTitle("", for: .normal)
                        self.turnGainBySourceButton.setTitle("", for: .normal)
                        self.meatNetByLevelButton.setTitle("", for: .normal)
                    }
                }else{
                    
                    self.turnSpentByAreaButton.isEnabled = true
                    self.turnSpentPerLevelButton.isEnabled = true
                    self.turnGainBySourceButton.isEnabled = true
                    self.meatNetByLevelButton.isEnabled = true
                    
                }
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    @IBAction func onTurnsSpentByAreaPress(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let horizontalViewcontroller = storyBoard.instantiateViewController(withIdentifier: "HorizontalBarGraphViewController") as! HorizontalBarGraphViewController
        
        //horizontalViewcontroller.modalPresentationStyle = .currentContext
        horizontalViewcontroller.parserModel = parserModel
        horizontalViewcontroller.type = "Area"
        horizontalViewcontroller.graphTitle = "Turns Spent Per Area"
        present(horizontalViewcontroller, animated: false, completion: nil)
    }
    @IBAction func onTurnsSpentPerLevelPress(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let horizontalViewcontroller = storyBoard.instantiateViewController(withIdentifier: "HorizontalBarGraphViewController") as! HorizontalBarGraphViewController
        
        //horizontalViewcontroller.modalPresentationStyle = .currentContext
        horizontalViewcontroller.parserModel = parserModel
        horizontalViewcontroller.type = "Level"
        horizontalViewcontroller.graphTitle = "Turns Spent Per Level"
        present(horizontalViewcontroller, animated: false, completion: nil)
    }
    @IBAction func onTurnGainBySourcePress(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let pieViewController = storyBoard.instantiateViewController(withIdentifier: "PieGraphViewController") as! PieGraphViewController
        
        //horizontalViewcontroller.modalPresentationStyle = .currentContext
        pieViewController.parserModel = parserModel
        present(pieViewController, animated: false, completion: nil)
    }
    @IBAction func onMeatNetByLevelPress(_ sender: Any) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let positiveNegativeViewController = storyBoard.instantiateViewController(withIdentifier: "PositiveNegativeBarChartViewController") as! PositiveNegativeBarChartViewController
        
        //horizontalViewcontroller.modalPresentationStyle = .currentContext
        positiveNegativeViewController.parserModel = parserModel
        present(positiveNegativeViewController, animated: false, completion: nil)
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: false) {
            self.document?.close(completionHandler: nil)
            self.tabBarController?.viewControllers?.forEach { let _ = $0.view }
            
        }
    }
}
