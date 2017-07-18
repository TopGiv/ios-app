//
//  NewEventViewController.swift
//  TopGiv
//
//  Created by Michael Feigenson on 6/14/17.
//  Copyright © 2017 Mark. All rights reserved.
//

import UIKit
import EventKit

class NewEventViewController: UIViewController {
    
    
    @IBOutlet var lb_Date: UILabel!
    @IBOutlet var lb_Starttime: UILabel!
    @IBOutlet var lb_Endtime: UILabel!
    @IBOutlet var lb_Eventtitle: UILabel!
    @IBOutlet var lb_Eventlocation: UILabel!
    var eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    

    
    /*
    // M ARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    
    
    @IBAction func onAdd(_ sender: Any) {
        
        let eventStore = EKEventStore()
        self.insertEvent(eventStore: eventStore)
        self.dismiss(animated: true) {
        }
    }
    
    func insertEvent(eventStore: EKEventStore) {
        
        addEventToCalendar(title: lb_Eventtitle.text!, description: lb_Eventlocation.text, startDate: NSDate() as Date, endDate: NSDate().addingTimeInterval(3600) as Date)
 
    }

    
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        
        let eventStore = EKEventStore()
        
        let status = EKEventStore.authorizationStatus(for: .event)
        
        switch (status)
        {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            break
        case EKAuthorizationStatus.authorized:
            // User has access
            print("User has access to calendar")
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = description
                    event.calendar = eventStore.defaultCalendarForNewEvents
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
            break
        }
        
        
    }
    
    
/*
    func  addEvent() {
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event, completion: {
            granted, error in
        
//        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
         
                let event:EKEvent = EKEvent(eventStore: self.eventStore)
                
                event.title = "Test Title"
                event.startDate = Date()
                event.endDate = event.startDate.addingTimeInterval(20000)
                event.notes = "This is a note"
                event.calendar = self.eventStore.defaultCalendarForNewEvents
                
                do {
                    try self.eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error : \(error)")
                }
                print("Saved Event")
            }
            else{
                
                print("failed to save event with error : \(error) or access not granted")
            }
        })
    }
    
*/
}
