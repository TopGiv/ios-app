//
//  AddEventViewController.swift
//  TopGiv
//
//  Created by Artemis on 7/25/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import Former
import EventKit

class AddEventViewController: FormViewController {
    
    var titlePassed = ""
    var placePassed = ""
    var startTimePassed = ""
    var endTimePassed = ""
    var datePassed = ""
    var eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    var isAllDay = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //This is for Navigation Bar
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        
        self.view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: "Add Event")
        
        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: nil, action: #selector(AddEventViewController.onAdd))        //'Add' button
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: nil, action: #selector(AddEventViewController.onCancel))        //Cancel button
        
        navItem.rightBarButtonItem = addItem
        
        navItem.leftBarButtonItem = cancelItem
        
        navBar.setItems([navItem], animated: false)
        
        let labelSpace = LabelRowFormer<FormLabelCell>()
            
            .configure { row in
                
                row.text = ""
                
            }.onSelected { row in
                // Do Something
        }
        
        //This is the title of the event
        let labelTitle = LabelRowFormer<FormLabelCell>()
            
            .configure { row in
                
                row.text = titlePassed
                
            }.onSelected { row in
                // Do Something
        }
        
        //This is the place of the event
        let labelPlace = LabelRowFormer<FormLabelCell>()
            
            .configure { row in
                
                row.text = placePassed
                
            }.onSelected { row in
                // Do Something
        }
        
        //This is for frequency
        let inlinePickerRepeat = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            
            $0.titleLabel.text = "Repeat"
            
            }.configure { row in
                
                row.pickerItems.append(InlinePickerItem(title: "Never"))
                
                row.pickerItems.append(InlinePickerItem(title: "Daily"))
                
                row.pickerItems.append(InlinePickerItem(title: "Weekly"))
                
                row.pickerItems.append(InlinePickerItem(title: "Monthly"))
                
                row.pickerItems.append(InlinePickerItem(title: "Yearly"))
                
            }.onValueChanged { item in
                // Do Something
        }
        
        //This is for all-day or not
        let switchRow = SwitchRowFormer<FormSwitchCell>() {
            
            $0.titleLabel.text = "All-day"
            
            }.configure { row in
                
            }.onSwitchChanged { row in
                
                // Do something
                self.isAllDay = row
                
        }
        
        //This is the start time
        let inlineDatePickerRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            
            $0.titleLabel.text = "Starts"
            
            }.configure { row in
                
            }.onDateChanged { item in
                
        }
        
        //This is the end time
        let inlineDatePickerRowB = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            
            $0.titleLabel.text = "Ends"
            
            }.configure { row in
                
            }.onDateChanged { item in
                
        }
        
        //This is for the alert
        let inlinePickerAlert = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
            $0.titleLabel.text = "Alert"
            }.configure { row in
                row.pickerItems.append(InlinePickerItem(title: "None"))
                
                row.pickerItems.append(InlinePickerItem(title: "At time of the event"))
                
                row.pickerItems.append(InlinePickerItem(title: "5 minutes before"))
                
                row.pickerItems.append(InlinePickerItem(title: "30 minutes before"))
                
                row.pickerItems.append(InlinePickerItem(title: "1 hour before"))
                
                row.pickerItems.append(InlinePickerItem(title: "1 day before"))
                
            }.onValueChanged { item in
                // Do Something
        }
        
        //This is for URL
        let labelURL = LabelRowFormer<FormLabelCell>()
            .configure { row in
                
                row.text = "URL"
                
            }.onSelected { row in
                // Do Something
        }
        
        //This is for comments
        let textNote = TextFieldRowFormer<FormTextFieldCell>()
            .configure { row in
                
                row.placeholder = "You can add notes here"
                
            }.onSelected { row in
                // Do something
        }
        
        //Header
        let header = LabelViewFormer<FormLabelHeaderView>() { view in
        }
        
        //Footer
        let footer = LabelViewFormer<FormLabelFooterView>() { view in
        }
        
        let sectionTop = SectionFormer(rowFormer: labelSpace).set(headerViewFormer: header)     //This is for space
        
        let sectionHeader = SectionFormer(rowFormer: labelTitle, labelPlace)        //This is for header content
        
        let sectionMid = SectionFormer(rowFormer: switchRow, inlineDatePickerRow, inlineDatePickerRowB, inlinePickerRepeat, inlinePickerAlert)      //This is for middle section
        
        let sectionFooter = SectionFormer(rowFormer: labelURL, textNote).set(footerViewFormer: footer)      //This is for footer content
        
        former.append(sectionFormer: sectionTop)
        
        former.append(sectionFormer: sectionHeader)
        
        former.append(sectionFormer: sectionMid)
        
        former.append(sectionFormer: sectionFooter)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func insertEvent(eventStore: EKEventStore) {
        
        addEventToCalendar(title: titlePassed, description: placePassed, startDate: NSDate() as Date, endDate: NSDate().addingTimeInterval(3600) as Date)
        
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        let eventStore = EKEventStore()
        
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch (status)
        {
            
        case EKAuthorizationStatus.notDetermined:
            
            // This happens on first-run
            print("Not determined")
            
            break
            
        case EKAuthorizationStatus.authorized:
            
            // User has access
            print("User has access to calendar")
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                
                if (granted) && (error == nil) {
                    
                    let event = EKEvent(eventStore: eventStore)
                    
                    event.title = title         //Title of the event to be stored
                    
                    event.startDate = startDate //Start date of the event to be stored
                    
                    event.endDate = endDate     //End date of the event to be stored
                    
                    event.notes = description   //Notes for the event to be stored
                    
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    
                    event.isAllDay = self.isAllDay
                    
                    event.location = self.placePassed
                    
                    do {
                        
                        try eventStore.save(event, span: .thisEvent)
                        
                    } catch let errora as NSError {
                        
                        completion?(false, errora)
                        
                        return
                        
                    }
                    
                    completion?(true, nil)
                    
                } else {
                    
                    completion?(false, error as NSError?)
                    
                }
                
            })
            
            break
            
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            
            // We need to help them give us permission
            print("Restricted")
            
            break
            
        }
        
    }
    
    func onAdd() {
        //This is when Add button is clicked
        
        let eventStore = EKEventStore()
        
        self.insertEvent(eventStore: eventStore)        //This is the actoiin of storing the event to a calendar
        
        self.dismiss(animated: true) {          //Go back to the previous view
        }
        
    }
    
    func onCancel() {
        //This is when Cancel button is clicked
        
        self.dismiss(animated: true) {          //Go back to the previous view
        }
        
    }
    
}
