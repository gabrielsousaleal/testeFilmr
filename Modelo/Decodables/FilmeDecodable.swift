//
//  Filme.swift
//  testeFilmr
//
//  Created by Gabriel Sousa on 15/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation

class ListaFilmes: Decodable {
    
    let filmr_projects: [FilmeDecodable]
    
}

class FilmeDecodable: Decodable {
    
    let name: String?
    let thumbnail_url: String?
    let video_url: String?
    
}
