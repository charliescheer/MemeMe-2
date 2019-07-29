//
//  Meme.swift
//  MemeMe
//
//  Created by Charlie Scheer on 7/29/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let image: UIImage
    let meme: UIImage
    
    init(_ topText: String, _ bottomText: String, _ originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = originalImage
        self.meme = memedImage
    }
    
    
}
