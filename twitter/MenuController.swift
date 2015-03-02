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
    var delegate: MenuControllerDelegate?
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)

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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row = indexPath.row
        
        switch row {
            case 0: delegate?.showProfile()
            case 1: delegate?.showTimeline()
            case 2: delegate?.showMentions()
            default: delegate?.showTimeline()
        }
    }
}


protocol MenuControllerDelegate {
    func toggleLeftPanel()
    func showProfile()
    func showTimeline()
    func showMentions()
}
