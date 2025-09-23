enum SettingsCellType: Identifiable, CaseIterable {
    var id: Self { self }
    
    case notifications
    case privacy
    case aboutDeveloper
    
    var urlString: String {
        switch self {
            case .privacy:
                "https://sites.google.com/view/birddays/privacy-policy"
            case .aboutDeveloper:
                "https://sites.google.com/view/birddays/home"
            default:
                ""
        }
    }
    
    var title: String {
        switch self {
            case .notifications:
                "Notifications"
            case .privacy:
                "Privacy Policy"
            case .aboutDeveloper:
                "About Developer"
        }
    }
}
