//
//  MessagesEntity+CoreDataProperties.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 20.06.2023.
//
//

import Foundation
import CoreData


extension MessagesEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessagesEntity> {
        return NSFetchRequest<MessagesEntity>(entityName: "MessagesEntity")
    }

    @NSManaged public var text: String
    @NSManaged public var date: Date
    @NSManaged public var avatarImageData: Data?
    @NSManaged public var messageIdentifier: UUID

}

extension MessagesEntity : Identifiable {

}
