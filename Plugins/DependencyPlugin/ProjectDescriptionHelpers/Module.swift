import ProjectDescription

public enum ModulePath {
    case app(App)
    case feature(Feature)
    case domain(Domain)
    case core(Core)
    case shared(Shared)
}

// MARK: - App

public extension ModulePath {
    enum App: String, CaseIterable {
        public static let name: String = "App"
        case iOS
    }
}

// MARK: - Feature

public extension ModulePath {
    enum Feature: String, CaseIterable {
        public static let name: String = "Feature"
        case AppCoordinator
        case Tab
        case Splash
        case Common
        case Onboarding
        case Home
        case Profile
        case Plan
        case Map
    }
}

// MARK: - Domain

public extension ModulePath {
    enum Domain: String, CaseIterable {
        public static let name: String = "Domain"
        case Entity
        case Service
        case Data
    }
}

// MARK: - Core

public extension ModulePath {
    enum Core: String, CaseIterable {
        public static let name: String = "Core"
        case Network
        case KeyChain
        case UserDefault
        case Repository
        case JWT
    }
}

// MARK: - Shared

public extension ModulePath {
    enum Shared: String, CaseIterable {
        public static let name: String = "Shared"
        case DesignSystem
        case Util
        case Logger
        case ThirdParty
        case ThirdPartyAuth
    }
}
