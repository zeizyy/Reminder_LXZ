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
  //  @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedDate: UITextField!        // due time for the event
    @IBOutlet weak var reminderDate: UITextField!        // reminder time for the event
    
    var timeSelected: UITextField!    // help identify which time selected
    
    // TODO create a outlet for descField

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
        self.configureView()

        titleField.delegate = self
        
        descField.delegate = self
        
        // add placeholder for textView
        if(descField.text.isEmpty){
            descField.text = placeholder
            descField.textColor = UIColor.lightGrayColor()
        }
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* handle two date fields*/
    @IBAction func dateEditing(sender: UITextField) {
        let datePickerView  : UIDatePicker = UIDatePicker()
        sender.inputView = datePickerView
        timeSelected = sender
        datePickerView.addTarget(self, action: "datePickerAction:", forControlEvents: UIControlEvents.AllEvents)
 //       datePicker.addTarget(self, action: "handleDatePicker:", forControlEvents: UIControlEvents.AllEvents)
    }
    
    // when datePicker changes
    @IBAction func datePickerAction(sender: UIDatePicker) {
     //   updateSelectedDateFromDatePicker()
        if let timeSelected = self.timeSelected {     // mark: was selectedDate
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let strDate = dateFormatter.stringFromDate(sender.date)
            //            selectedDate.text = strDate
            timeSelected.text = strDate
        }
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

    // MARK: Helper methods

//    func updateSelectedDateFromDatePicker() {
//        if let timeSelected = self.timeSelected {     // mark: was selectedDate
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//            var strDate = dateFormatter.stringFromDate(sender.date)
////            selectedDate.text = strDate
//            timeSelected.text = strDate
//        }
//    }

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
            if let descField = self.descField {
                descField.text = item.desc
            }
        } else {
            // create a new object
        }
    }

    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if saveButton === sender {
            if let item = self.detailItem {
                item.title = titleField.text ?? ""
                item.desc = descField.text ?? ""
                print(descField.text)
                item.createTime = NSDate()
  //              item.eventTime = datePicker.date
            }
        } else { // cancelButton
//            context.deleteObject(detailItem!)
            context.rollback()
        }

        do {
            try context.save()
        } catch {
        }
    }


}

