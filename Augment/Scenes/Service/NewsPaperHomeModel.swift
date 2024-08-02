import Foundation

struct NewsPaperHomeModel: Codable {
    let id: String
    let record: Record
    let metadata: Metadata
}

struct Record: Codable {
    let headerLogo: String
    let subscription: Subscription
    
    enum CodingKeys: String, CodingKey {
        case headerLogo = "header_logo"
        case subscription
    }
}

struct Subscription: Codable {
    let offerPageStyle: String
    let coverImage: String
    let subscribeTitle: String
    let subscribeSubtitle: String
    let offers: [String: Offer]
    let benefits: [String]
    let disclaimer: String
    
    enum CodingKeys: String, CodingKey {
        case offerPageStyle = "offer_page_style"
        case coverImage = "cover_image"
        case subscribeTitle = "subscribe_title"
        case subscribeSubtitle = "subscribe_subtitle"
        case offers
        case benefits
        case disclaimer
    }
}

struct Offer: Codable {
    let price: Double
    let description: String
}

struct Metadata: Codable {
    let name: String
    let readCountRemaining: Int
    let timeToExpire: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case readCountRemaining
        case timeToExpire
        case createdAt
    }
}
