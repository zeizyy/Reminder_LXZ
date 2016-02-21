//
//  EventMO.swift
//  Reminder_LXZ
//
//  Created by 🐻堑 on 2/16/16.
//  Copyright © 2016 Yuanyang Zheng. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class EventMO: NSManagedObject {

    @NSManaged var title: String!
    @NSManaged var desc: String?
    @NSManaged var eventTime: NSDate!
    @NSManaged var createTime: NSDate!
    
    convenience init(title: String!, desc: String?, eventTime: NSDate!, createTime: NSDate!, entity: NSEntityDescription, insertIntoManagedObjectContext context : NSManagedObjectContext!){
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.title = title
        self.desc = desc
        self.eventTime = eventTime
        self.createTime = createTime
    }

}