//
//  DocumentViewController.swift
//  KoLVisualizer
//
//  Created by Tommy Lu on 4/29/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var document: Document?
    
    @IBOutlet weak var logPlainText: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open(completionHandler: { (success) in
            if success {
                // Display the content of the document, e.g.:
                self.logPlainText.text = self.document?.userText
                self.navigationBar.topItem?.title = self.document?.fileURL.lastPathComponent
                if self.logPlainText.text.contains("Ascension Log Visualizer"){
                    //parse
                }
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: false) {
            self.document?.close(completionHandler: nil)
            self.tabBarController?.viewControllers?.forEach { let _ = $0.view }
            
        }
    }
}
