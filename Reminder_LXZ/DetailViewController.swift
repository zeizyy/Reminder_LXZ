//
//  DetailViewController.swift
//  Reminder_LXZ
//
//  Created by Yuanyang Zheng on 2/12/16.
//  Copyright © 2016 Yuanyang Zheng. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    let placeholder = "Description"

    // MARK: Properties

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextView!
    @IBOutlet weak var selectedDate: UITextField!
    // due time for the event
    @IBOutlet weak var reminderDate: UITextField!
    // reminder time for the event

    let dateFormatter = NSDateFormatter()

    var timeSelected: UITextField!
    // help identify which time selected

    var detailItem: EventMO? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    var context: NSManagedObjectContext!

    // MARK: Events

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        self.configureView()

        titleField.delegate = self

        descField.delegate = self

        // add placeholder for textView
        if (descField.text.isEmpty) {
            descField.text = placeholder
            descField.textColor = UIColor.lightGrayColor()
        }
        
        checkValidEvent()

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        titleField.becomeFirstResponder()
    }

    
    // remove the hard-coded placeholder when textView is being edited
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }

    // add the hard-coded placeholder when end editing
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        checkValidEvent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /* handle two date fields*/
    @IBAction func dateEditing(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        
        // set default display of datePicker to current selected time
        var displayTime  = NSDate()
        if sender == self.selectedDate {
            displayTime = (self.detailItem?.eventTime)!
        } else if sender == self.reminderDate {
            displayTime = (self.detailItem?.reminderTime)!
        }
        datePickerView.setDate(displayTime, animated: false)
        
        // link to datePicker
        sender.inputView = datePickerView
        timeSelected = sender
        datePickerView.addTarget(self, action: "datePickerAction:", forControlEvents: UIControlEvents.AllEvents)
    }

    // when datePicker changes
    func datePickerAction(sender: UIDatePicker) {
        //   updateSelectedDateFromDatePicker()
        if let timeSelected = self.timeSelected {
            // mark: was selectedDate
            let strDate = dateFormatter.stringFromDate(sender.date)
            //            selectedDate.text = strDate
            var displayString = ""

            if timeSelected == self.reminderDate {
                self.detailItem?.reminderTime = sender.date
                displayString = "Remind me at: " + strDate
            } else if timeSelected == self.selectedDate {
                self.detailItem?.eventTime = sender.date
                displayString = "Due at: " + strDate
            }
            timeSelected.text = displayString

        }
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        checkValidEvent()
//    }
    
    @IBAction func textFieldDidChange(sender: UITextField) {
        checkValidEvent()
    }
    
    // return key pressed while editing a text field.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

    // dismiss keyboard when user taps background
    @IBAction func userTappedBackground(sender: AnyObject) {
        view.endEditing(true)
    }
    
    func checkValidEvent(){
        let title = titleField.text ?? ""
        let desc = descField.text ?? ""
        let descColor = descField.textColor == UIColor.lightGrayColor()
        saveButton.enabled = !title.isEmpty && !desc.isEmpty && !descColor
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
            if let selectedDate = self.selectedDate {
   //             print("hi there: " + dateFormatter.stringFromDate(item.eventTime))
                let selectedDateString = dateFormatter.stringFromDate(item.eventTime)
                selectedDate.text = "Due at: " + selectedDateString
            }
            if let reminderDate = self.reminderDate {
                let reminderDateString = dateFormatter.stringFromDate(item.reminderTime)
                reminderDate.text = "Remind me at: " + reminderDateString
            }
            if let descField = self.descField {
                descField.text = item.desc
            }
        }
    }

    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if saveButton === sender {
            if let item = self.detailItem {
                item.title = titleField.text ?? ""
                item.desc = descField.text ?? ""
                item.createTime = NSDate()
                //item.reminderTime = dateFormatter.dateFromString(reminderDate.text!)
                //item.eventTime = dateFormatter.dateFromString(selectedDate.text!)
            }
        } else {
            // cancelButton
            //            context.deleteObject(detailItem!)
            context.rollback()
        }

        do {
            try context.save()
        } catch {
            print("unable to save!")
        }
    }


}

