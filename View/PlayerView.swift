//
//  PlayerView.swift
//  testeFilmr
//
//  Created by Gabriel Sousa on 16/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class PlayerView: UIView {
        
    override class var layerClass: AnyClass {
           return AVPlayerLayer.self
       }
}
