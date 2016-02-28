//
//  MasterViewController.swift
//  Reminder_LXZ
//
//  Created by Yuanyang Zheng on 2/12/16.
//  Copyright © 2016 Yuanyang Zheng. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var timer = NSTimer()
    let dateFormatterShort = NSDateFormatter()
    let dateFormatterLong = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count - 1] as! UINavigationController).topViewController as? DetailViewController
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "checkReminder", userInfo: nil, repeats: true)
        dateFormatterShort.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatterLong.dateFormat = "yyyy'-'MM'-'dd HH':'mm':'ss"

    }
    
    func test(){
        print("1")
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) -> EventMO {
        let context = self.fetchedResultsController.managedObjectContext
        let entity = self.fetchedResultsController.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as! EventMO

        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        //        newManagedObject.setValue("New Title", forKey: "title")
        //        newManagedObject.setValue(NSDate(), forKey: "createTime")

        // use model to hold data instead of KVC
        newManagedObject.title = ""
        newManagedObject.desc = ""
        newManagedObject.eventTime = NSDate(timeIntervalSinceNow: NSTimeInterval(3600))
        newManagedObject.reminderTime = NSDate()
        newManagedObject.createTime = NSDate()
        return newManagedObject
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {


        if segue.identifier == "showDetail" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController

                // print("we're at master view: " + dateFormatter.stringFromDate(((object as? EventMO)?.reminderTime)!))
                // pass the object to the target controller
                controller.detailItem = object as? EventMO
            }
//            controller.context = self.fetchedResultsController.managedObjectContext

            // this overrides the cancel button set in the storyboard
            //            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //            controller.navigationItem.leftItemsSupplementBackButton = true

        } else if segue.identifier == "createDetail" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            controller.detailItem = insertNewObject(sender!)

            // this overrides the cancel button set in the storyboard
            //            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            //            controller.navigationItem.leftItemsSupplementBackButton = true

//            controller.context = self.fetchedResultsController.managedObjectContext

        }


    }

    // getting back to masterView i.e. receiving segues
    @IBAction func unwindToEventList(sender: UIStoryboardSegue) {
    
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)

            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("Unresolved error \(error), \(error.userInfo)")
                abort()
            }
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */


    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! EventMO
        cell.textLabel!.text = object.title
        
        cell.detailTextLabel!.text = dateFormatterLong.stringFromDate(object.eventTime!)
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "eventTime", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController

        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }

        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    func checkReminder(){
        print("---------------")
        let currentTime = dateFormatterLong.stringFromDate(NSDate())
        print(currentTime)
        for event in self.fetchedResultsController.fetchedObjects as! [EventMO] {
            let reminderTime = dateFormatterLong.stringFromDate(event.reminderTime)
            print(reminderTime)
            if reminderTime == currentTime {
                let message = event.title + " is due!"
                let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let postponeAction = UIAlertAction(title: "Postpone",style: .Default) {
                    UIAlertAction in
                    event.reminderTime = event.reminderTime.dateByAddingTimeInterval(NSTimeInterval(3600))
                }
                let addAction = UIAlertAction(title: "Dismiss", style: .Default){
                    UIAlertAction in
                    self.managedObjectContext?.deleteObject(event)
                    do {
                        try self.managedObjectContext?.save()
                    } catch {
                        print("unable to save")
                    }
                }
//                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                alert.addAction(postponeAction)
                alert.addAction(addAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    /*
    // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
    // In the simplest, most efficient, case, reload the table view.
    self.tableView.reloadData()
    }
    */

}

