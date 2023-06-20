//
//  CoreDataManager.swift
//  InvoltaTestTask
//
//  Created by Alexey Poletaev on 19.06.2023.
//

import CoreData
import UIKit

final class CoreDataManager {

    static let shared = CoreDataManager()
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.Strings.CoreData.containerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    private lazy var viewContext = persistentContainer.viewContext

    private init() {}

    /// Saves changes to the managed object context, if any changes exist.
    private func saveContext() {
        if viewContext.hasChanges {
            try? viewContext.save()
        }
    }

    func addMessage(_ message: MessageModel) {
        let messagesEntity = MessagesEntity(context: viewContext)
        messagesEntity.messageIdentifier = message.messageIdentifier
        messagesEntity.text = message.text
        messagesEntity.date = message.date
        messagesEntity.avatarImageData = message.image?.pngData()
        saveContext()
    }

    func removeMessage(_ messageIdentifier: UUID) {
        let fetchRequest: NSFetchRequest<MessagesEntity> = MessagesEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "messageIdentifier == %@", messageIdentifier as CVarArg)
        if let result = try? viewContext.fetch(fetchRequest),
           let message = result.first {
            viewContext.delete(message)
            saveContext()
        }
    }

    /// Retrieves the list of favorite repositories from the managed object context.
    /// - Returns: An array of `RepositoryEntity` objects representing the favorite repositories.
    func loadMessages() -> [MessageModel] {
        let fetchRequest: NSFetchRequest<MessagesEntity> = MessagesEntity.fetchRequest()
        let messages = try? viewContext.fetch(fetchRequest)
        switch messages {
        case .none:
            return []
        case .some(let messagesUnwrap):
            var messagesModel: [MessageModel] = []
            messagesUnwrap
                .sorted(by: { $0.date > $1.date })
                .forEach { messageEntity in
                let image: UIImage? = UIImage(data: messageEntity.avatarImageData!)
                    messagesModel.append(.init(messageIdentifier: messageEntity.messageIdentifier, text: messageEntity.text, date: messageEntity.date, image: image))
            }
            return messagesModel
        }
    }
}
