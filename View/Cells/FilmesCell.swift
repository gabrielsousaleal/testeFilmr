//
//  FilmesCell.swift
//  testeFilmr
//
//  Created by Gabriel Sousa on 16/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit

class FilmesCell: UICollectionViewCell {
    
    @IBOutlet var thumView: UIImageView!
    
    @IBOutlet var nomeLabel: UILabel!
    
    override func awakeFromNib() {

        self.layer.borderWidth = 8
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    
}
