//
//  DetailViewController.swift
//  Reminder_LXZ
//
//  Created by Yuanyang Zheng on 2/12/16.
//  Copyright © 2016 Yuanyang Zheng. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {

    // MARK: Properties
    let ITEMS_KEY = "Event"
    // cells
    @IBOutlet weak var titleCell: UITableViewCell!
    @IBOutlet weak var dueDateCell: UITableViewCell!
    @IBOutlet weak var remindDateCell: UITableViewCell!
    @IBOutlet weak var descCell: UITableViewCell!

    // currently editing cell
    private var cellBeingEdited: UITableViewCell? = nil

    // fields
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextView!


    // misc
    let picker = UIDatePicker()
    let placeholder = "Description"
    let dateFormatter: NSDateFormatter = NSDateFormatter()
//    var context: NSManagedObjectContext!
    var detailItem: EventMO? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


    // MARK: Events

    override func viewDidLoad() {
        super.viewDidLoad()

        titleField.delegate = self
        descField.delegate = self
        titleField.hidden = true
        descField.hidden = true
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        self.configureView()
        self.checkValidEvent()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        titleField.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            self.performSegueWithIdentifier("cancel", sender: nil)
        }
    }

    // remove the hard-coded placeholder when textView is being edited
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        self.updateDatePickers()
    }

    // add the hard-coded placeholder when end editing
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        }
        
    }

    func textViewDidChange(textView: UITextView) {
        self.checkValidEvent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//    /* handle two date fields*/
//    @IBAction func dateEditing(sender: UITextField) {
//        let datePickerView: UIDatePicker = UIDatePicker()
//        
//        // set default display of datePicker to current selected time
//        var displayTime  = NSDate()
//        //        if sender == self.selectedDate {
//        //            displayTime = (self.detailItem?.eventTime)!
//        //        } else if sender == self.reminderDate {
//        //            displayTime = (self.detailItem?.reminderTime)!
//        //        }
//        datePickerView.setDate(displayTime, animated: false)
//        
//        // link to datePicker
//        sender.inputView = datePickerView
//        timeSelected = sender
//        datePickerView.addTarget(self, action: "datePickerAction:", forControlEvents: UIControlEvents.AllEvents)
//    }

    // when datePicker changes
    @IBAction func updateLabelFromDatePicker(sender: UIDatePicker) {
        //   updateSelectedDateFromDatePicker()
        //        if let timeSelected = self.timeSelected {
        //            // mark: was selectedDate
        //            let strDate = dateFormatter.stringFromDate(sender.date)
        //            //            selectedDate.text = strDate
        //            var displayString = ""
        //
        //            if timeSelected == self.reminderDate {
        //                self.detailItem?.reminderTime = sender.date
        //                displayString = "Remind me at: " + strDate
        //            } else if timeSelected == self.selectedDate {
        //                self.detailItem?.eventTime = sender.date
        //                displayString = "Due at: " + strDate
        //            }
        //            timeSelected.text = displayString
        //
        //        }
//        let datePickerRow = tableView.indexPathForCell(sender.).row
        let selectedRow = tableView.indexPathForSelectedRow!.row
        switch selectedRow {
        case tableView.indexPathForCell(dueDateCell)!.row:
            dueDateCell.detailTextLabel?.text = dateFormatter.stringFromDate(sender.date)
            self.detailItem?.eventTime = sender.date
        case tableView.indexPathForCell(remindDateCell)!.row:
            remindDateCell.detailTextLabel?.text = dateFormatter.stringFromDate(sender.date)
            self.detailItem?.reminderTime = sender.date
        default:
            break
        }
    }


    @IBAction func textFieldDidChange(sender: UITextField) {
        self.checkValidEvent()
    }

    // return key pressed while editing a text field.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    // MARK: TableViewController

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == tableView.indexPathForCell(titleCell)!.row {
            self.cellBeingEdited = self.titleCell
        } else if (indexPath.row == tableView.indexPathForCell(dueDateCell)!.row) {
            if cellBeingEdited == dueDateCell {
                cellBeingEdited = nil
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                picker.becomeFirstResponder()
                cellBeingEdited = dueDateCell
            }

        } else if (indexPath.row == tableView.indexPathForCell(remindDateCell)!.row) {
            if cellBeingEdited == remindDateCell {
                cellBeingEdited = nil
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            } else {
                cellBeingEdited = remindDateCell
            }
        } else if indexPath.row == tableView.indexPathForCell(descCell)!.row {
            self.cellBeingEdited = self.descCell
        }
        
        self.updateContentOfInputCells()
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (cellBeingEdited != dueDateCell) && (indexPath.row == 2) {
            return 0
        } else if (cellBeingEdited != remindDateCell) && (indexPath.row == 4) {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }


    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            if let item = self.detailItem {
                item.title = titleField.text ?? ""
                item.desc = descField.text ?? ""
                item.createTime = NSDate()
                item.reminderTime = dateFormatter.dateFromString(remindDateCell.detailTextLabel!.text!)
                item.eventTime = dateFormatter.dateFromString(dueDateCell.detailTextLabel!.text!)
                if (item.uuid == nil) {      // new object
                    item.uuid = NSUUID().UUIDString
                } else {                     // editing object->delete old notification
                    for notification in UIApplication.sharedApplication().scheduledLocalNotifications! as [UILocalNotification] { // loop through notifications...
                        print(notification.userInfo)
                        if let uuid = notification.userInfo!["UUID"] {
                        if (uuid as! String == item.uuid) { // ...and cancel the notification that corresponds to this TodoItem instance (matched by UUID)
                            UIApplication.sharedApplication().cancelLocalNotification(notification) // there should be a maximum of one match on UUID
                            print("editing...delete: " + item.uuid)
                            break
                        }
                        }
                    }
                }
            }
        } else {
            // cancelButton
            //            context.deleteObject(detailItem!)
            let controller = segue.destinationViewController as! MasterViewController
            controller.managedObjectContext!.rollback()
        }

        do {
            let controller = segue.destinationViewController as! MasterViewController
            try controller.managedObjectContext!.save()
        } catch {
            print("unable to save!")
        }
        
        if saveButton === sender {
            if let item = self.detailItem {
                var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary()
                todoDictionary[item.uuid] = ["deadline": item.eventTime, "title": item.title, "UUID": item.uuid] // store NSData representation of todo item in dictionary with UUID as key
                NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY)

            let notification = UILocalNotification()
            let eventTimeString = dateFormatter.stringFromDate(item.eventTime)
            notification.alertBody = "Todo Item \"\(item.title)\" will be due on \(eventTimeString)"  // text that \ill be displayed in the notification
            notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
            notification.fireDate = item.reminderTime // todo item due date (when notification will be fired)
            notification.soundName = UILocalNotificationDefaultSoundName // play default sound
            //               notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
//            let userInfoCurrent = notification.userInfo as! [String: AnyObject]
            
            //let uid = userInfoCurrent["uid"]! as! String
            notification.userInfo = ["UUID": item.uuid, ]
            print("saving: "+item.uuid)
            notification.category = "TODO_CATEGORY"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
            }
    }



    // MARK: Helper methods


    func configureView() {
        // Update the user interface for the detail item.
        if let item = self.detailItem {
            if let titleField = self.titleField {
                titleField.text = item.title
            }
            //            let date = item.eventTime
            //            if let datePicker = self.datePicker {
            //                datePicker.setDate(date!, animated: false)
            //                updateSelectedDateFromDatePicker()
            //            }
            if let cell = self.dueDateCell {
                //             print("hi there: " + dateFormatter.stringFromDate(item.eventTime))
                let selectedDateString = dateFormatter.stringFromDate(item.eventTime)
                cell.textLabel!.text = "Due at"
                cell.detailTextLabel!.text = selectedDateString
                // TODO style the detailTextLabel text
            }
            if let cell = self.remindDateCell {
                let reminderDateString = dateFormatter.stringFromDate(item.reminderTime)
                cell.textLabel!.text = "Remind at"
                cell.detailTextLabel!.text = reminderDateString
            }
            if let descField = self.descField {
                descField.text = item.desc

                // add placeholder for textView
                if (descField.text.isEmpty) {
                    descField.text = placeholder
                    descField.textColor = UIColor.lightGrayColor()
                }

            }
        }

    }

    private func updateContentOfInputCells() {
        // for title field
        updateTitleCell()
        updateDescCell()

        // for datepickers
        updateDatePickers()
    }
    
    private func updateDatePickers(){
        tableView.beginUpdates()
        tableView.endUpdates()
    }


    private func updateTitleCell() {
        if cellBeingEdited == titleCell {
            self.showTitleFieldAndHideLabel()
        } else {
            hideTitleFieldAndShowLabel()
        }
    }

    private func hideTitleFieldAndShowLabel() {
        titleField.hidden = true
        titleCell.textLabel?.hidden = false
        titleCell.textLabel?.text = titleField.text
        titleField.resignFirstResponder()
    }

    private func showTitleFieldAndHideLabel() {
        titleField.hidden = false
        titleCell.textLabel?.hidden = true
        titleField.becomeFirstResponder()
    }
    
    private func updateDescCell() {
        if cellBeingEdited == descCell {
            self.showDescFieldAndHideLabel()
        } else {
            hideDescFieldAndShowLabel()
        }
    }
    private func hideDescFieldAndShowLabel() {
        descField.hidden = true
        descCell.textLabel?.hidden = false
        descCell.textLabel?.text = descField.text
        descField.resignFirstResponder()
    }
    
    private func showDescFieldAndHideLabel() {
        descField.hidden = false
        descCell.textLabel?.hidden = true
        descField.becomeFirstResponder()
    }


    private func checkValidEvent() {
        let title = titleField.text ?? ""
        let desc = descField.text ?? ""
        let descColor = descField.textColor == UIColor.lightGrayColor()
        saveButton.enabled = !title.isEmpty && !desc.isEmpty && !descColor
    }


}

