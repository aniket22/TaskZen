import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
}

extension Task: Identifiable {
    @NSManaged public var timestamp: Date?
    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
}
