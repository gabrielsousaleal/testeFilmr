//
//  testeFilmrTests.swift
//  testeFilmrTests
//
//  Created by Gabriel Sousa on 15/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import XCTest
@testable import testeFilmr

class testeFilmrTests: XCTestCase {
    
    var dao: DAO!
    var filmesVC: FilmesViewController!

    override func setUp() {
        
        dao = DAO()
        
    }

    override func tearDown() {
    }

    //TESTES DOWNLOADS DOS JSON
    func testarDownloadDaURLLogo(){
        
        let exp = expectation(description: "Pegar URL logo")
        
        var urlLogo: URL?
        
        dao.baixarLogoUrl { url in

            urlLogo = URL(string: url)
            exp.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) { erro in
            
            if let erro = erro {
                 XCTFail("waitForExpectationsWithTimeout errored: \(erro)")
            }
            
            print("URL da logo:", urlLogo!)
            
            XCTAssertFalse(urlLogo == nil)
        
        }
        
    }
    
    func testarDownloadDaURLSite(){
        
        let exp = expectation(description: "Pegar URL site")
        
        var urlSite: URL?
        
        dao.baixarSite { url in

            urlSite = URL(string: url)
            exp.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) { erro in
            
            if let erro = erro {
                 XCTFail("waitForExpectationsWithTimeout errored: \(erro)")
            }
            
            print("URL do site:", urlSite!)
            
            XCTAssertFalse(urlSite == nil)
         
           }
    }
    
    func testarDownloadDosFilmes(){
        
        let exp = expectation(description: "Pegar filmes")
        
        var filmes: [FilmeDecodable]?
        
        let quantidadeDeFilmesEsperada = 7
        
        dao.baixarFilmes { resultado in
            
            filmes = resultado
            exp.fulfill()
            
        }
        
        waitForExpectations(timeout: 10) { erro in
            
            if let erro = erro {
                 XCTFail("waitForExpectationsWithTimeout errored: \(erro)")
            }
            
            print("Filmes:", filmes!)
            
            //NAO PODE SER NULO
            XCTAssertFalse(filmes == nil)
            //QUANTIDADE DE RESULTADOS DEVE SER IGUAL A QUANTIDADE ESPERADA
            XCTAssertEqual(quantidadeDeFilmesEsperada, filmes!.count)
         
           }
        
    }
    
}
    
