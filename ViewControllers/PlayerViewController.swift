//
//  PlayerViewController.swift
//  testeFilmr
//
//  Created by Gabriel Sousa on 16/10/19.
//  Copyright © 2019 Gabriel Sousa. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class PlayerViewController: UIViewController {
    
    //MARK: STORYBOARD OUTLETS
    @IBOutlet var botaoVoltar: UIButton!
    @IBOutlet var videoView: UIView!
    @IBOutlet var nomeLabel: UILabel!
    @IBOutlet var siteBotao: UIButton!
    @IBOutlet var menuView: UIView!
    
    
    //MARK: VARIAVEIS
    var filme: FilmeDecodable?
    var player: AVPlayer?
    var observable: Any?
    var loading: UIActivityIndicatorView?
    var carregando = true
    var estaNoMenu = false
    var estaPausado = false
    var site: String?
    
    
    //MARK: FUNCOES DA VIEW
    override func viewDidLoad() {
        
        addGesture()
        
        popularView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         player?.removeTimeObserver(observable!)
     }
    
    
    //MARK: LAYOUT
    func popularView(){
        
        guard let _ = filme else { return }
               
        let viewModel = FilmeVM(filme: filme!)
        
        nomeLabel.text = viewModel.getNomeVideo()
        
        DAO().baixarSite { resultado in
            
            self.site = resultado
            
        }
        
        guard let url = viewModel.getUrlVideo() else { return }
                                
        iniciarVideo(url: url)
        
    }
    
    func mostrarAlert(mensagem: String){
        
        let alert = UIAlertController(title: "Ops!", message: mensagem, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
        
    }
 
    
    
    //MARK: FULLSCREEN
    func addGesture(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(mostrarMenu))
        tap.numberOfTapsRequired = 1
        
        self.videoView.addGestureRecognizer(tap)
        
    }
    
    
    
    //MARK: VIDEO
    func iniciarVideo(url: URL){
        
        mostrarLoading()
        
        player = AVPlayer(url: url)
       
        configurarPlayerLayer()
       
        player!.play()
        
        addObservables()
        
        }
    
    func addObservables(){
        
        observable = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main, using: { time in
              self.carregando = false
              self.loading?.stopAnimating()
          })
        
          NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player!.currentItem, queue: .main) { _ in
                  DispatchQueue.main.async {
                      self.player!.seek(to: CMTime.zero)
                      self.player!.play()
                  }
              }
        
    }
    
    func configurarPlayerLayer(){
        
        let playerLayer = videoView.layer as! AVPlayerLayer
               playerLayer.player = player
               playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
               player!.automaticallyWaitsToMinimizeStalling = true
               playerLayer.borderColor = #colorLiteral(red: 0.1087812409, green: 0.5274432898, blue: 0.9343807101, alpha: 1)
               playerLayer.borderWidth = 1
        
    }
    
    func mostrarLoading() {
        loading = UIActivityIndicatorView()
        loading!.frame = videoView.bounds
        loading?.center.x = self.view.center.x - 10
        loading?.color = .white
        loading!.hidesWhenStopped = true
        videoView.addSubview(loading!)
        loading!.startAnimating()
    }
    
    @objc func mostrarMenu(gesture: UITapGestureRecognizer){
        
        if carregando { return }
        
        if estaNoMenu {
            estaNoMenu = false
            menuView.isHidden = false
        } else {
            estaNoMenu = true
            menuView.isHidden = true
        }
        
    }
    
    
    //MARK: STORYBOARD ACTIONS
    
    @IBAction func voltar(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
                
    }
    
    @IBAction func irParaOSite(_ sender: Any) {
        
        guard let site = site else {
            
            mostrarAlert(mensagem: "Falha ao encontrar o site")
            
            return
            
        }
        
        guard let url = URL(string: site) else {
            
            mostrarAlert(mensagem: "Há algum problema com o site, tente mais tarde")
            
            return
            
        }
        
        UIApplication.shared.open(url)
        
    }
    
    @IBAction func pausar(_ sender: UIButton) {
        
        var imagem: UIImage?
        
        if estaPausado {
            imagem = UIImage(named: "pause")
            player?.play()
            estaPausado = false
            menuView.isHidden = true
            estaNoMenu = false
        } else {
            imagem = UIImage(named: "play")
            player?.pause()
            estaPausado = true
        }
        
        sender.setImage(imagem, for: .normal)
        
    }
    
}
