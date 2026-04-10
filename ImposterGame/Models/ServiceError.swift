import Foundation

enum ServiceError: Error, Equatable {
    case network
    case decoding(String)
    case notFound
    case remoteConfigUnavailable
    case productsUnavailable
    case purchaseCancelled
    case purchasePending
    case purchaseFailed(String)
    case adNotReady
    case timeout
    case unknown
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network: return "Network unavailable."
        case .decoding(let details): return "Failed to decode response: \(details)"
        case .notFound: return "Requested resource was not found."
        case .remoteConfigUnavailable: return "Remote Config is unavailable."
        case .productsUnavailable: return "In-app products could not be loaded."
        case .purchaseCancelled: return "Purchase was cancelled."
        case .purchasePending: return "Purchase is pending approval."
        case .purchaseFailed(let details): return "Purchase failed: \(details)"
        case .adNotReady: return "Ad is not ready to display."
        case .timeout: return "The operation timed out."
        case .unknown: return "An unknown error occurred."
        }
    }
}
