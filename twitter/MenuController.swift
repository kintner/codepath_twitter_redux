//
//  MenuController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/28/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//


class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var menuItems = ["Profile", "Timeline", "Mentions"]
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("menu-cell") as MenuCell
        
        var text = menuItems[indexPath.row]
        
        
        cell.textLabel?.text = text
        
        return cell
    }
    
}
