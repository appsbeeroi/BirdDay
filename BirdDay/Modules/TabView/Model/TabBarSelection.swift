import UIKit

enum TabBarSelection: Identifiable, CaseIterable {
    var id: Self { self }
    
    case catalog
    case calendar
    case diary
    case settings
    
    var icon: ImageResource {
        switch self {
            case .catalog:
                    .Images.TabView.catalog
            case .calendar:
                    .Images.TabView.calendar
            case .diary:
                    .Images.TabView.diary
            case .settings:
                    .Images.TabView.settings
        }
    }
}
