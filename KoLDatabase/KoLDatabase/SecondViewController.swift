//
//  SecondViewController.swift
//  KoLDatabase
//
//  Created by Tommy Lu on 4/29/19.
//  Copyright © 2019 Tommy Lu. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchFooter: SearchFooter!
    
    var detailViewController: DetailViewController? = nil

    var items = [Item]()
    var filteredItems = [Item]()
    let searchController = UISearchController(searchResultsController: nil)
    let itemsModel = ItemsModel()
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.viewControllers?.forEach { let _ = $0.view }
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Items"
        self.definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.definesPresentationContext = true
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Equipment", "Food", "Drink"]
        searchController.searchBar.delegate = self
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        
        items = itemsModel.itemTable
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredItems.count, of: items.count)
            return filteredItems.count
        }

        searchFooter.setNotFiltering()
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item: Item
        if isFiltering() {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        cell.textLabel!.text = item.name
        cell.detailTextLabel!.text = "ItemID: \(String(item.ID)), Item Usage: \(item.use)"
        return cell
    }
    
    //Presents new view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        //Find best context to hold tab view, or just leave commented
        newViewController.modalPresentationStyle = .overCurrentContext
        // Return search when done
        newViewController.searchController = searchController
        
        let food = "food"
        
        let drink = "drink"
        var item:Item
        if isFiltering(){
            item = filteredItems[indexPath.row]
        }else{
            item = items[indexPath.row]
        }
        // Set descriptions for item in pop up
        newViewController.itemName = item.name
        newViewController.IDAndUse = "Item ID: \(item.ID) | Item Use: \(item.use)"
        newViewController.autosell = "Autosell Value: \(item.autosell)"
        
        //Set power or quality
        if self.isEquipment(item: item){
            newViewController.qualityAndPower = String((itemsModel.equipmentDatabase[item.name]?.power)!)
        }else if item.use.contains(food){
            newViewController.qualityAndPower = (itemsModel.foodDatabase[item.name]?.quality)!
        }else if item.use.contains(drink){
            newViewController.qualityAndPower = (itemsModel.drinkDatabase[item.name]?.quality)!
        }else{
            newViewController.qualityAndPower = ""
        }
        
        //Set fullness or inebriety
        if item.use.contains(food){
            newViewController.qualityAndPower = String((itemsModel.foodDatabase[item.name]?.fullness)!)
        }else if item.use.contains(drink){
            newViewController.qualityAndPower = String((itemsModel.drinkDatabase[item.name]?.inebriety)!)
        }else{
            newViewController.qualityAndPower = ""
        }
        
        //Set requirements
        if self.isEquipment(item: item){
            newViewController.qualityAndPower = (itemsModel.equipmentDatabase[item.name]?.requirements)!
        }else if item.use.contains(food){
            newViewController.qualityAndPower = String((itemsModel.foodDatabase[item.name]?.level)!)
        }else if item.use.contains(drink){
            newViewController.qualityAndPower = String((itemsModel.drinkDatabase[item.name]?.level)!)
        }else{
            newViewController.qualityAndPower = ""
        }
        
        //Set Modifier List
        var modifierTextBoxString = ""
        if itemsModel.modifierDatabase[item.name] != nil{
            for modifier in (itemsModel.modifierDatabase[item.name]?.modifiersList)!{
                modifierTextBoxString = "\(modifierTextBoxString)\(modifier)\n"
            }
        }
        newViewController.modifierList = modifierTextBoxString
        
        if isFiltering(){
            newViewController.searchControllerSearch = searchController.searchBar.text!
            searchController.isActive = false
            newViewController.wasActive = true
        }else{
            newViewController.wasActive = false
        }
        
        self.present(newViewController, animated: false, completion: nil)
        
    }

    func isEquipment(item: Item) -> Bool{
        let equipment = ["hat", "weapon", "offhand", "container", "shirt", "pants","accessory"]
        
        for equip in equipment{
            if item.use.contains(equip){
                return true
            }
        }
        return false
    }
    // MARK: - Private instance methods
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredItems = items.filter({( item : Item) -> Bool in
            var doesCategoryMatch = (scope == "All") || (item.use.contains(scope.lowercased()))
            
            if scope == "Equipment"{
                if self.isEquipment(item: item){
                    doesCategoryMatch = true
                }
            }
            
            if searchBarIsEmpty() {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && item.name.lowercased().contains(searchText.lowercased())
            }
        })
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
}

extension MasterViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension MasterViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
