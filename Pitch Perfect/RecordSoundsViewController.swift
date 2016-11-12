//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ivan Kodrnja on 06/03/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewWillAppear(_ animated: Bool) {
        //hide the stop button
        stopButton.isHidden = true
        pauseButton.isHidden = true
        resumeRecordingButton.isHidden = true
        
        recordButton.isEnabled = true
        
        recordingLabel.isHidden = false
        recordingLabel.text = "Tap to Record"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordAudio(_ sender: UIButton) {
    
        // recordingLabel.hidden = false
        recordingLabel.text = "recording"
        stopButton.isHidden = false
        pauseButton.isHidden = false
        
        recordButton.isEnabled = false
      
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
        }
        do {
            try session.setActive(true)
        } catch _ {
        }
        
        
        do {
        audioRecorder = try AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        } catch {
            
        }
    
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if(flag){
            recordedAudio = RecordedAudio(filePathUrlTemp: recorder.url, titleTemp: recorder.url.lastPathComponent)
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func pauseRecording(_ sender: UIButton) {
        
        audioRecorder.pause()
        pauseButton.isHidden = true
        recordingLabel.text = "Recording paused. Press red button to resume."
        resumeRecordingButton.isHidden = false
        
    }
    
    @IBAction func resumeRecording(_ sender: UIButton) {
        
        audioRecorder.record()
        resumeRecordingButton.isHidden = true
        pauseButton.isHidden = false
        recordingLabel.text = "recording"
        
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        
        recordingLabel.isHidden = true
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
        
    }

}

