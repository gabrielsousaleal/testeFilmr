//
//  FilmesViewController.swift
//  testeFilmr
//
//  Created by Gabriel Sousa on 15/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit

class FilmesViewController: UIViewController {
    
    //MARK: STORYBORAD OUTLETS
    @IBOutlet var viewCima: UIView!
    @IBOutlet var logoView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    
    //MARK: STORYBOARD CONSTRAINTS
    @IBOutlet var viewCimaTopConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewTopConstraint: NSLayoutConstraint!
    
    
    var listaFilmes: [FilmeDecodable] = []
    private var ultimoItemMostradoCollection: CGFloat = 0
    
    
    //MARK: FUNCOES DA VIEW
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        travarPortrait(.portrait)
        
        setarLayoutCells()
        
        setupNavigationController(navigationController: self.navigationController!)
     
        setarDelegates()
        
        baixarFilmes() { _ in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        baixarLogo { logo in
            DispatchQueue.main.async {
                self.logoView.image = logo
            }
        }
    }
    
    
    
    //MARK: FUNCOES DE CHAMADA
    func baixarFilmes( completion: @escaping (Bool) -> () ) {
        
        DAO().baixarFilmes { listaFilmes in
                        
            self.listaFilmes = listaFilmes
            
            completion(true)
            
        }
        
    }
    
    func baixarLogo(completion: @escaping (UIImage) -> () ) {
        
        DAO().baixarLogoUrl { url in
                        
            DAO().baixarImagem(link: url) { imagem in
                
                completion(imagem)
            
            }
            
        }
    
    }
    
    func setarDelegates() {
        
        collectionView.delegate = self
        
        collectionView.dataSource = self
        
    }
    
    
    //MARK: LAYOUT
    
    func setarLayoutCells(){
        
        let screen = UIScreen.main.bounds
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
        layout.itemSize = CGSize(width: screen.width - 30, height: 243)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 26
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func setupNavigationController(navigationController: UINavigationController) {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.view.backgroundColor = .clear
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.barStyle = .black
    }
    
    func travarPortrait(_ orientation: UIInterfaceOrientationMask) {

        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
}

extension FilmesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        return listaFilmes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilmesCell", for: indexPath) as! FilmesCell
        
        let filme = listaFilmes[indexPath.row]
        
        let modelView = FilmeVM(filme: filme)
        
        modelView.getThumbUIImage { imagem in
            DispatchQueue.main.async {
                cell.thumView.image = imagem
            }
        }
    
        cell.nomeLabel.text = modelView.getNomeVideo()

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let filme = listaFilmes[indexPath.row]
        
        let playerVC = UIStoryboard(name: "PlayerStoryboard", bundle: nil).instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController
        
        playerVC?.filme = filme
        
        navigationController?.pushViewController(playerVC!, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        let scrollOffset = scrollView.contentOffset.y
        
        let estaNoFinal = scrollOffset + scrollViewHeight >= scrollContentSizeHeight
                
        if (self.ultimoItemMostradoCollection > scrollView.contentOffset.y) && !estaNoFinal {
            
            self.viewCimaTopConstraint.constant = 0
            self.logoView.alpha = 1
            
        } else {
            
            let viewCimaHeigh = self.collectionView.frame.origin.y
                        
            var offset = min(scrollView.contentOffset.y, viewCimaHeigh)
            
            if offset > 42 {
                offset = 40.5
            }

            if offset >= 0 || self.collectionViewTopConstraint.constant != 0 {
                self.viewCimaTopConstraint.constant = -offset
                let percent = max(1 - offset/(viewCimaHeigh)*2,0)
                self.logoView.alpha = percent
            }
            
        }
        
        self.ultimoItemMostradoCollection = scrollView.contentOffset.y
    
        
    }
    
}
