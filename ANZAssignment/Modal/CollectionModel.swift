//
//  AboutCanadaModel.swift
//  ANZAssignment
//
//  Created by Ravi Mishra on 24/04/18.
//  Copyright © 2018 Capgemini. All rights reserved.
//

import UIKit


struct CollectionModel: Codable {
    var rows : [ListDetails]
}
struct ListDetails: Codable {
    let imageDescription: String?
    let imageUrlRefrence: String?
    let title: String?
    private enum CodingKeys: String, CodingKey {
        case imageDescription = "description"
        case imageUrlRefrence = "imageHref"
        case title = "title"
        }
}
