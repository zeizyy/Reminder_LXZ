//
//  DetailViewController.swift
//  Reminder_LXZ
//
//  Created by Yuanyang Zheng on 2/12/16.
//  Copyright © 2016 Yuanyang Zheng. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var selectedDate: UILabel!
    
    @IBAction func datePickerAction(sender: UIDatePicker) {
        updateSelectedDateFromDatePicker()
    }
    
    func updateSelectedDateFromDatePicker(){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        self.selectedDate.text = strDate
    }
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let item = self.detailItem as! EventMO? {
            if let titleField = self.titleField {
                titleField.text = item.title
            }
            let date = item.eventTime
            if let datePicker = self.datePicker {
                datePicker.setDate(date!, animated:false)
                updateSelectedDateFromDatePicker()
            }
        } else {
            // create a new object
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        titleField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if saveButton === sender {
            if let item = self.detailItem as! EventMO? {
                item.title = titleField.text ?? ""
                item.desc = ""
                item.createTime = NSDate()
                item.eventTime = datePicker.date
            }
        } else {
            detailItem = nil
        }
    }
    
    
}

