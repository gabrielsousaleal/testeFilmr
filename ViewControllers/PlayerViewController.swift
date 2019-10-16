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
    
    
    //MARK: VARIAVEIS
    var filme: FilmeDecodable?
    var player: AVPlayer?
    var observable: Any?
    
    override func viewDidLoad() {
                
        guard let _ = filme else { return }
        
        let viewModel = FilmeVM(filme: filme!)
        
        guard let url = viewModel.getUrlVideo() else { return }
        
        player = AVPlayer(url: url)
        
        iniciarVideo()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.removeTimeObserver(observable)
    }
    
    func iniciarVideo(){
        
        let playerLayer = videoView.layer as! AVPlayerLayer
        playerLayer.player = player
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        player!.play()
        player!.automaticallyWaitsToMinimizeStalling = true
        playerLayer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        playerLayer.borderWidth = 4
        
        observable = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main, using: { time in
            print(1)
        })
      
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player!.currentItem, queue: .main) { _ in
                DispatchQueue.main.async {
                    self.player!.seek(to: CMTime.zero)
                    self.player!.play()
                }
            }
        
        }
    
    @IBAction func voltar(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
                
    }
    
    @IBAction func irParaOSite(_ sender: Any) {
    }
    

}
