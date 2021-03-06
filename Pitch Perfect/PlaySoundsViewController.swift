//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ivan Kodrnja on 09/03/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

 
    var audioPlayer: AVAudioPlayer!
    var audioPlayerEcho: AVAudioPlayer!
    
    var receivedAudio:RecordedAudio!
    var audioFile:AVAudioFile!
    var audioEngine: AVAudioEngine!
    
    var reverbPlayers:[AVAudioPlayer] = []
    let N = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = try? AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayer.enableRate = true
        
        // instantiate the second copy of the audio file for the echo effect
        //audioPlayerEcho = self.audioPlayer
        audioPlayerEcho = try? AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        audioPlayerEcho.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try? AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        
        
        // initialize reverb effect audio players
        for _ in 0...N{
            let temp = try? AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
            
            reverbPlayers.append(temp!)
        }
        
        
        //This piece of code (AVAudioSessionCategoryPlayback) will cause the audio to play from the best place for output
        let session = AVAudioSession.sharedInstance()
        do {
            if #available(iOS 10.0, *) {
                //try session.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: <#AVAudioSession.Mode#>)
                try session.setCategory(.playAndRecord, mode: .default, options: [])
            } else {
                // Fallback on earlier versions
            }
        } catch  {
            print("couldn't set category \(error)")
            return
        }
        do {
            try session.setActive(true)
        } catch  {
            print("couldn't set category active \(error)")
            return
        }
        
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
  
    @IBAction func playSlowAudio(_ sender: UIButton) {
        
        self.stopAllAudio()
        
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    
    @IBAction func playFastAudio(_ sender: UIButton) {
        
        self.stopAllAudio()
        // play audio fast
        audioPlayer.rate = 2.0
        audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @IBAction func playChipmunkAudio(_ sender: UIButton) {
        playAudioWithVariablePitch(1000)

    }
    
    
    @IBAction func playDarthvaderAudio(_ sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(_ pitch: Float){
        self.stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
    }
    
    @IBAction func playEchoSound(_ sender: UIButton) {
        self.stopAllAudio()
        
        // reset rate value to default, otherwise playSlowAudio or playFastAudio will still be implemented
        audioPlayer.rate = 1.0
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        
        
        
        let delay:TimeInterval = 0.1//100ms
        var playtime:TimeInterval
        playtime = audioPlayerEcho.deviceCurrentTime + delay

        audioPlayerEcho.currentTime = 0
        audioPlayerEcho.volume = 0.8;
        audioPlayerEcho.play(atTime: playtime)
        
    }
    
    
    @IBAction func playReverbSound(_ sender: UIButton) {
        self.stopAllAudio()
        
        let delay:TimeInterval = 0.02
        
        for i in 0...N{
            let currentDelay:TimeInterval = delay * TimeInterval(i)
            
            let player:AVAudioPlayer = reverbPlayers[i]
            
            let exponent:Double = -Double(i)/Double(N/2)
            let volume = Float(pow(Double(M_E), exponent))
            player.volume = volume
            player.play(atTime: player.deviceCurrentTime + currentDelay)
            }
    }
    
    // called from functions in the code
    func stopAllAudio() {
        
        audioPlayer.stop()
        audioPlayerEcho.stop()
        
        audioEngine.stop()
        audioEngine.reset()
        
        for i in 0...N{
            let player:AVAudioPlayer = reverbPlayers[i]
            
            player.stop()
            player.currentTime = 0
        }
    }
    
    // called by pressing the button
    @IBAction func stopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayerEcho.stop()
        
        audioEngine.stop()
        audioEngine.reset()
        
        for i in 0...N{
            let player:AVAudioPlayer = reverbPlayers[i]
            
            player.stop()
        }
    }


}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
