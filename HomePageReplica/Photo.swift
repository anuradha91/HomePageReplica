//
//  Photo.swift
//  HomePageReplica
//
//  Created by Anuradha Sharma on 10/28/18.
//  Copyright © 2018 Anuradha Sharma. All rights reserved.
//

import Foundation
import UIKit

struct Photo {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: URL {
        return URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
}
