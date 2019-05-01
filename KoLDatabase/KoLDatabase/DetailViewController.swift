/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var IDAndUseLabel: UILabel!
    @IBOutlet weak var autosellLabel: UILabel!
    @IBOutlet weak var qualityAndPowerLabel: UILabel!
    @IBOutlet weak var fullnessAndIneberityLabel: UILabel!
    @IBOutlet weak var requirementsLabel: UILabel!
    @IBOutlet weak var modifierListTextView: UITextView!
    
    var itemName: String?
    var IDAndUse: String?
    var autosell: String?
    var qualityAndPower: String?
    var fullnessAndIneberity: String?
    var requirements: String?
    var modifierList: String?
    var searchController: UISearchController?
    var wasActive: Bool?
    var searchControllerSearch: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemNameLabel.text = itemName
        IDAndUseLabel.text = IDAndUse
        autosellLabel.text = autosell
        qualityAndPowerLabel.text = qualityAndPower
        fullnessAndIneberityLabel.text = fullnessAndIneberity
        requirementsLabel.text = requirements
        modifierListTextView.text = modifierList
    }
    
    @IBAction func dismissDetailViewController(_ sender: Any) {
        dismiss(animated: false) {
            self.tabBarController?.viewControllers?.forEach { let _ = $0.view }
            if self.wasActive!{
                self.searchController?.isActive = true
                self.searchController?.searchBar.text = self.searchControllerSearch
            }
            
        }
    }
    
}

