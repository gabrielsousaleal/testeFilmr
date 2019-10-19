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
    @IBOutlet var botaoVoltarNoVideo: UIButton!
    @IBOutlet var botaoAvancarNoVideo: UIButton!
    @IBOutlet var slider: UISlider!
    @IBOutlet var tempoAtual: UILabel!
    @IBOutlet var tempoMaximo: UILabel!
    @IBOutlet var botaoPlay: UIButton!
    @IBOutlet var fullscreen: UIView!
     @IBOutlet var videoContainer: UIView!
    @IBOutlet var slider2: UISlider!
    @IBOutlet var botaoPlay2: UIButton!
    @IBOutlet var tempoAtual2: UILabel!
    @IBOutlet var tempoMaximo2: UILabel!
    
    
    //MARK: VARIAVEIS
    var filme: FilmeDecodable?
    var player: AVPlayer?
    var observable: Any?
    var loading: UIActivityIndicatorView?
    var carregando = true
    var estaPausado = false
    var site: String?
    var tempoMaximoInt: Int?
    var tempoAtualInt: Int?
    var estaFullScreen = false
    var playerLayer: AVPlayerLayer?
    var antigoFrameVideoView: CGRect?
   
    
    
    //MARK: FUNCOES DA VIEW
    override func viewDidLoad() {
        
        liberarLandscape(.all)
        
        addGesture()
        
        popularView()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
         player?.removeTimeObserver(observable!)
     }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
            
            if estaFullScreen { return }
            
            estaFullScreen = true
     
            fullscreen.isHidden = false
            
            configurarVideoLandscape()

        } else {
            
            if !estaFullScreen { return }
            
            menuView.isHidden = true
            
            fullscreen.isHidden = true
            
            estaFullScreen = false
            
            configurarVideoPortrait()
            
         }
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
    
    func liberarLandscape(_ orientation: UIInterfaceOrientationMask) {

           if let delegate = UIApplication.shared.delegate as? AppDelegate {
               delegate.orientationLock = orientation
           }
       }
    
    func configurarVideoLandscape(){
        
        antigoFrameVideoView = videoView.frame
                     
         videoView.translatesAutoresizingMaskIntoConstraints = true
         
         videoView.layer.borderWidth = 0

         fullscreen.addSubview(videoView)
         
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
         fullscreen.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0),
         fullscreen.bottomAnchor.constraint(equalToSystemSpacingBelow: guide.bottomAnchor, multiplier: 1.0),
         fullscreen.leadingAnchor.constraint(equalToSystemSpacingAfter: guide.leadingAnchor, multiplier: 1.0),
         fullscreen.trailingAnchor.constraint(equalToSystemSpacingAfter: guide.trailingAnchor, multiplier: 1.0)
         ])
         
         let window = UIApplication.shared.keyWindow
         
         videoView.frame = CGRect(x: -window!.safeAreaInsets.bottom , y: 0, width: fullscreen.frame.height, height: fullscreen.frame.width )
        
    }
    
    func configurarVideoPortrait(){
        
         videoView.frame = CGRect(x: 0, y: 0, width: videoContainer.frame.height, height:  videoContainer.frame.width)
                  
         videoView.translatesAutoresizingMaskIntoConstraints = false
        
         videoView.layer.borderWidth = 1
                                        
         videoContainer.addSubview(videoView)
                  
         let top = NSLayoutConstraint(item: videoView!, attribute: .top, relatedBy: .equal, toItem: videoContainer, attribute: .top, multiplier: 1, constant: 0)

         let bottom = NSLayoutConstraint(item: videoView!, attribute: .bottom, relatedBy: .equal, toItem: videoContainer, attribute: .bottom, multiplier: 1, constant: 0)

         let left = NSLayoutConstraint(item: videoView!, attribute: .left, relatedBy: .equal, toItem: videoContainer, attribute: .left, multiplier: 1, constant: 0)

         let right = NSLayoutConstraint(item: videoView!, attribute: .right, relatedBy: .equal, toItem: videoContainer, attribute: .right, multiplier: 1, constant: 0)
                  
         let heigh =  videoView.heightAnchor.constraint(equalTo: videoContainer.heightAnchor, multiplier: 1.0)
                  
         let widht =  videoView.widthAnchor.constraint(equalTo: videoContainer.widthAnchor, multiplier: 1.0)

         NSLayoutConstraint.activate([top,bottom,left,right,heigh,widht])
        
    }
 
    
    
    //MARK: GESTURE
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
    
    func popularMenu() {
        
        //PEGANDO O VALOR EM SEGUNDOS DO TEMPO MAXIMO DO VIDEO
        let valorMaximo = self.player?.currentItem?.duration.value
        let timescaleMaximo = self.player?.currentItem?.duration.timescale
        if valorMaximo == 0 { return }
        self.tempoMaximoInt = Int(valorMaximo!) / Int(timescaleMaximo!)
        
        //COLOCANDO O VALOR NO SLIDER (PORTRAIT E LANDSCAPE)
        self.slider.maximumValue = Float(self.tempoMaximoInt!)
        self.slider2.maximumValue = Float(self.tempoMaximoInt!)
        
        //CONVERTENDO SEGUNDOS EM MINUTOS
        let minutosMaximo = (self.tempoMaximoInt! % 3600) / 60
        let segundosMaximmo = (self.tempoMaximoInt! % 3600) % 60
        
        var segundosStringMaximo = ""
        
        //CONFIGURANDO LABEL DE SEGUNDOS
        if segundosMaximmo < 10 {
            segundosStringMaximo = "0\(segundosMaximmo)"
        } else {
            segundosStringMaximo = "\(segundosMaximmo)"
        }
        
        
        self.tempoMaximo.text = "\(minutosMaximo):\(segundosStringMaximo)"
        self.tempoMaximo2.text = "\(minutosMaximo):\(segundosStringMaximo)"
        
        //PEGANDO O VALOR EM SEGUNDOS DO TEMPO ATUAL DO VIDEO
        let valorAtual = self.player?.currentItem?.currentTime().value
        let timescaleAtual = self.player?.currentItem?.currentTime().timescale
        self.tempoAtualInt = Int(valorAtual!) / Int(timescaleAtual!)
        
        //COLOCANDO O VALOR NO SLIDER (PORTRAIT E LANDSCAPE)
        self.slider.value = Float(self.tempoAtualInt!)
        self.slider2.value = Float(self.tempoAtualInt!)
        
        //CONVERTENDO SEGUNDOS EM MINUTOS
        let minutosAtual = (self.tempoAtualInt! % 3600) / 60
        let segundosAtual = (self.tempoAtualInt! % 3600) % 60
        
        
        var segundosStringAtual = ""
                   
        if segundosAtual < 10 {
            segundosStringAtual = "0\(segundosAtual)"
            } else {
            segundosStringAtual = "\(segundosAtual)"
        }
        
        self.tempoAtual.text = "\(minutosAtual):\(segundosStringAtual)"
        self.tempoAtual2.text = "\(minutosAtual):\(segundosStringAtual)"
        
        
        //SE O VIDEO ACABAR, TROCAR A IMAGEM DO BOTAO DE PLAY
        if self.tempoAtualInt == self.tempoMaximoInt {
            
            self.botaoPlay.setImage(UIImage(named: "play"), for: .normal)
            self.botaoPlay2.setImage(UIImage(named: "play"), for: .normal)
            
        }
        
    }
    
    func addObservables(){
        
        //OBSERVADOR PARA CADA SEGUNDO DO VIDEO
        observable = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main, using: { time in
            
              self.carregando = false
            
              self.loading?.stopAnimating()
            
               self.popularMenu()
            
        
          })
        
    }
    
    func configurarPlayerLayer(){
        
        playerLayer = videoView.layer as? AVPlayerLayer
        playerLayer!.player = player
        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        player!.automaticallyWaitsToMinimizeStalling = true
        
    }
    
    func mostrarLoading() {
        
        loading = UIActivityIndicatorView()
        loading!.frame = CGRect(x: 0, y: 0, width:videoView.frame.width, height: videoView.frame.height)
        loading?.color = .white
        loading!.hidesWhenStopped = true
        videoView.addSubview(loading!)
        loading!.startAnimating()
        loading?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            NSLayoutConstraint(item: loading!, attribute: .centerX, relatedBy: .equal, toItem: videoView, attribute: .centerX, multiplier: 1, constant: 0),
            
             NSLayoutConstraint(item: loading!, attribute: .centerY, relatedBy: .equal, toItem: videoView, attribute: .centerY, multiplier: 1, constant: 0)
            
        ])
        
    }
    
    @objc func mostrarMenu(gesture: UITapGestureRecognizer){
        
        //MOSTRAR MENU APENAS QUANDO FULLSCREEN
        if carregando || !estaFullScreen { return }
        
        if menuView.isHidden {
            menuView.isHidden = false
        } else {
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
        } else {
            imagem = UIImage(named: "play")
            player?.pause()
            estaPausado = true
        }
        
        botaoPlay.setImage(imagem, for: .normal)
        botaoPlay2.setImage(imagem, for: .normal)
        
        //SE O VIDEO TIVER ACABO, REINICIAR
        if self.tempoAtualInt == self.tempoMaximoInt {
            
            self.botaoPlay.setImage(UIImage(named: "pause"), for: .normal)
            self.botaoPlay2.setImage(UIImage(named: "pause"), for: .normal)
            
            player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
            
            player?.play()
            
            estaPausado = false
            
        }
        
        
    }
    
    @IBAction func voltarNoVideo(_ sender: Any) {
        
        let valorVoltar : Float64 = 5

              if player == nil { return }
              if let duration  = player!.currentItem?.duration {
              let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
              let newTime = playerCurrentTime - valorVoltar
              if newTime < CMTimeGetSeconds(duration)
              {
                  let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                  player!.seek(to: selectedTime)
              }
              player?.pause()
              player?.play()
              }
        
    }
    
    @IBAction func avancarNoVideo(_ sender: Any) {
        
        let valorAvancar : Float64 = 5

        if player == nil { return }
        if let duration  = player!.currentItem?.duration {
        let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
        let newTime = playerCurrentTime + valorAvancar
        if newTime < CMTimeGetSeconds(duration)
        {
            let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player!.seek(to: selectedTime)
        }
        player?.pause()
        player?.play()
        }
        
    }
    
    @IBAction func mudarTempoSlider(_ sender: UISlider) {
        
        if sender.restorationIdentifier == "slider2" {
            
            player?.seek(to: CMTime(seconds: Double(slider2!.value), preferredTimescale: 1))

        } else {
            
            player?.seek(to: CMTime(seconds: Double(slider!.value), preferredTimescale: 1))
            
        }
                
    }
    
}
