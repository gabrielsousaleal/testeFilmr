//
//  DAO.swift
//  testeFilmr
//
//  Created by Gabriel Sousa on 16/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit

class DAO {
    
    //MARK: DOWNLOAD JSONs
    func baixarFilmes(completion: @escaping ([FilmeDecodable]) -> () ){
        
        var listaFilmes: [FilmeDecodable] = []

        guard let url = URL(string: "https://elasticbeanstalk-us-east-1-508049151276.s3.amazonaws.com/FilmrTest/db.json") else { return }
        
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                            
            guard let data = data, error == nil else {return}
            
            do {
            
            let json = try JSONDecoder().decode(ListaFilmes.self, from: data)
                
                let semaforo = DispatchSemaphore.init(value: 1)
                
                for filme in json.filmr_projects {
                    
                    listaFilmes.append(filme)
                    
                    if listaFilmes.count == json.filmr_projects.count {
                        semaforo.signal()
                        completion(listaFilmes)
                    }
                    
                }
                
                 //USO DE SEMAFORO PARA ESPERAR QUE O FOR SEJA TOTALMENTE EXECUTADO
                 semaforo.wait()
                
            } catch {
                
                print(error)
                completion(listaFilmes)
                
            }
            
        }.resume()
        
    }
    
    func baixarSite(completion: @escaping (String) -> () ){
        
        var site: String?

        guard let url = URL(string: "https://elasticbeanstalk-us-east-1-508049151276.s3.amazonaws.com/FilmrTest/db.json") else { return }
        
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                            
            guard let data = data, error == nil else {return}
            
            do {
            
            let json = try JSONDecoder().decode(FilmrSiteDecodable.self, from: data)
                
                site = json.filmr_site
                
                completion(site ?? "")
                                                
            } catch {
                
                print(error)
                completion(site ?? "")
                
            }
            
        }.resume()
        
    }
    
    func baixarLogoUrl(completion: @escaping (String) -> () ){
        
        var logo: String?

        guard let url = URL(string: "https://elasticbeanstalk-us-east-1-508049151276.s3.amazonaws.com/FilmrTest/db.json") else { return }
        
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                            
            guard let data = data, error == nil else {return}
            
            do {
            
            let json = try JSONDecoder().decode(LogoFilmr.self, from: data)
                
                logo = json.filmr_logo
                
                completion(logo ?? "")
                                                
            } catch {
                
                print(error)
                completion(logo ?? "")
                
            }
            
        }.resume()
        
    }
    
    
    //MARK: DOWNLOAD DE MIDIAS
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func baixarImagem(link: String, completion: @escaping (UIImage) -> ()) {
        
        if let data = verificarURLUserdefaults(url: link) { completion( UIImage(data: data)! ) }
        
        guard let imagemURL = URL(string: link) else { return }
                
        getData(url: imagemURL) { data, response, error in
            
            guard let data = data, error == nil else { return }
            
            let imagem = UIImage(data: data) ?? UIImage()
            
            self.salvarImagemDataUserdefaults(data: data, url: link)
            
            completion(imagem)
            
        }
        
    }
    
    
    //MARK: USERDEFAULTS
    func salvarImagemDataUserdefaults( data: Data, url: String ) {
        
        UserDefaults.standard.set(data, forKey: url)
        
    }
    
    func verificarURLUserdefaults(url: String) -> Data? {
        
        if let data = UserDefaults.standard.data(forKey: url) {
            return data
        }
        
        return nil
        
    }
    
}
