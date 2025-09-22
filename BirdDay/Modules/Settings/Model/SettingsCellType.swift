enum SettingsCellType: Identifiable, CaseIterable {
    var id: Self { self }
    
    case notifications
    case privacy
    case aboutDeveloper
    
    #warning("доки")
    var urlString: String {
        switch self {
            case .privacy:
                "https://mail.google.com/mail/u/0/#inbox"
            case .aboutDeveloper:
                "https://mail.google.com/mail/u/0/#inbox"
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
