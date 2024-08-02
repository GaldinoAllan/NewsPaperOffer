//
//  NewsPaperHomeFactory.swift
//  Augment
//
//  Created by Allan Galdino on 02/08/24.
//

import UIKit

enum NewsPaperHomeFactory {
    static func make() -> UIViewController {
        let service = NewsPaperHomeService(apiUrl: NewsPaperHomeAPI.url, session: URLSession.shared)
        let viewModel = NewsPaperHomeViewModel(service: service)
    }
}
