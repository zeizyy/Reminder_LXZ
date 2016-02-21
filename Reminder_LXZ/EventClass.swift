//
//  EventClass.swift
//  Reminder_LXZ
//
//  Created by Yuanyang Zheng on 2/20/16.
//  Copyright © 2016 Yuanyang Zheng. All rights reserved.
//

import UIKit

class EventClass {
    
    var title: String!
    var desc: String?
    var eventTime: NSDate!
    var createTime: NSDate!
    
    init?(title: String!, desc: String?, eventTime: NSDate!, createTime: NSDate!){
        self.title = title
        self.desc = desc
        self.eventTime = eventTime
        self.createTime = createTime
    }
    
    init?(event: EventMO){
        self.title = event.title
        self.desc = event.desc
        self.eventTime = event.eventTime
        self.createTime = event.createTime
    }
    
}