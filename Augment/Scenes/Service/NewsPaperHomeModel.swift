import Foundation

struct NewsPaperHomeModel: Equatable, Decodable {
    let id: String
    let record: Record
    let metadata: Metadata
}

struct Record: Equatable, Decodable {
    let headerLogo: String
    let subscription: Subscription
    
    enum CodingKeys: String, CodingKey {
        case headerLogo = "header_logo"
        case subscription
    }
}

struct Subscription: Equatable, Decodable {
    let offerPageStyle: String
    let coverImage: String
    let subscribeTitle: String
    let subscribeSubtitle: String
    let offers: Offers
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

struct Offers: Equatable, Decodable {
    let id0: Offer
    let id1: Offer
}

struct Offer: Equatable, Decodable {
    let price: Double
    let description: String
}

struct Metadata: Equatable, Decodable {
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
