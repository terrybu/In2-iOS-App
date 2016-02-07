//
//  NoticeAdminViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 2/7/16.
//  Copyright © 2016 Terry Bu. All rights reserved.
//

import UIKit

class NoticeAdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView! 
    var savedNoticesArray: [Notice]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "공지사항"
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addNotice")
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        //Get Firebase notices
        FirebaseManager.sharedManager.getNoticeObjectsFromFirebase({
            (success) -> Void in
            self.savedNoticesArray = FirebaseManager.sharedManager.noticesArray
            self.tableView.reloadData()
        })
        
    }
    
    func addNotice() {
        print("add notice button pressed")
        let noticeCreationVC = NoticeCreationViewController()
        self.navigationController?.pushViewController(noticeCreationVC, animated: true)
    }
    
        //MARK: TableViewDataSource Protocol Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let savedNoticesArray = savedNoticesArray {
            return savedNoticesArray.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        let notice = savedNoticesArray![indexPath.row]
        cell.textLabel!.text = notice.title
        cell.detailTextLabel!.text = notice.date
        if notice.active == true {
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    //MARK: TableViewDelegate Protocol Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .Checkmark
            let notice = savedNoticesArray![indexPath.row]
            notice.active = true
            FirebaseManager.sharedManager.updateNoticeObjectActiveFlag(notice, completion: { (success) -> Void in
                //
                tableView.reloadData()
            })
        }
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .None
            let notice = savedNoticesArray![indexPath.row]
            notice.active = false
            FirebaseManager.sharedManager.updateNoticeObjectActiveFlag(notice, completion: { (success) -> Void in
                //
                tableView.reloadData()
            })
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}