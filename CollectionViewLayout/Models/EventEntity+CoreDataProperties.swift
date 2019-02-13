//
//  EventEntity+CoreDataProperties.swift
//  CollectionViewLayout
//
//  Created by David Perez on 1/10/19.
//  Copyright © 2019 David Perez P. All rights reserved.
//
//

import Foundation
import CoreData


extension EventEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventEntity> {
        return NSFetchRequest<EventEntity>(entityName: "EventEntity")
    }

    @NSManaged public var entityImage: NSData?
    @NSManaged public var entityNameString: String?
    @NSManaged public var entityCost: Double
    @NSManaged public var entityTime: String?

}
