//
//  ProjetosVM.swift
//  testeFilmr
//
//  Created by Gabriel Sousa on 15/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit

class FilmeVM {
    
    private let filme: FilmeDecodable
    
    init( filme: FilmeDecodable ) {
        
        self.filme = filme
        
    }
    
    func getThumbUIImage(completion: @escaping (UIImage) -> () )  {
                        
        DAO().baixarImagem(link: filme.thumbnail_url ?? "") { resultado in
      
            completion(resultado)
            
        }
                
    }
    
    func getNomeVideo() -> String {
        
        return filme.name ?? "Vídeo sem nome"
        
    }
    
}
