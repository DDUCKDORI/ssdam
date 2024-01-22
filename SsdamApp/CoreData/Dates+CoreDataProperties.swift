//
//  Dates+CoreDataProperties.swift
//  
//
//  Created by 김재민 on 1/22/24.
//
//

import Foundation
import CoreData


extension Dates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dates> {
        return NSFetchRequest<Dates>(entityName: "Dates")
    }

    @NSManaged public var completedAt: Date?

}
