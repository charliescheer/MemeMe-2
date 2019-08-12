//
//  Meme.swift
//  MemeMe
//
//  Created by Charlie Scheer on 7/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit

struct Meme: Codable {
    var topText: String
    var bottomText: String
    var image: UIImage
    var meme: UIImage
    
    enum CodingKeys: String, CodingKey {
        case topText
        case bottomText
        case image
        case meme
    }
    
    init(topText: String, bottomText: String, image: UIImage, meme: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.meme = meme
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        topText = try values.decode(String.self, forKey: .topText)
        bottomText = try values.decode(String.self, forKey: .bottomText)
        
        let imageData = try values.decode(Data.self, forKey: .image)
        let memeData = try values.decode(Data.self, forKey: .meme)
        
        if let decodedImage = UIImage.init(data: imageData), let decodedMeme = UIImage.init(data: memeData) {
            image = decodedImage
            meme = decodedMeme
        } else {
            image = UIImage()
            meme = UIImage()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topText, forKey: .topText)
        try container.encode(bottomText, forKey: .bottomText)
        guard let imageData = image.pngData() else {
            return
        }
        
        guard let memeData = meme.pngData() else {
            return
        }
        
        try container.encode(imageData, forKey: .image)
        try container.encode(memeData, forKey: .meme)
    }
}
