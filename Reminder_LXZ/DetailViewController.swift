//
//  DetailViewController.swift
//  Reminder_LXZ
//
//  Created by Yuanyang Zheng on 2/12/16.
//  Copyright © 2016 Yuanyang Zheng. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {


    // MARK: Properties

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectedDate: UILabel!
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
        // TODO set delegate for descField
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // when datePicker changes
    @IBAction func datePickerAction(sender: UIDatePicker) {
        updateSelectedDateFromDatePicker()
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

    func updateSelectedDateFromDatePicker() {
        if let selectedDate = self.selectedDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let strDate = dateFormatter.stringFromDate(datePicker.date)
            selectedDate.text = strDate
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let item = self.detailItem {
            if let titleField = self.titleField {
                titleField.text = item.title
            }
            let date = item.eventTime
            if let datePicker = self.datePicker {
                datePicker.setDate(date!, animated: false)
                updateSelectedDateFromDatePicker()
            }
            // TODO set descField content
        } else {
            // create a new object
        }
    }

    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if saveButton === sender {
            if let item = self.detailItem {
                item.title = titleField.text ?? ""
                item.desc = "" // TODO
                item.createTime = NSDate()
                item.eventTime = datePicker.date
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

