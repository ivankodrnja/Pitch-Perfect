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
    
    override func viewWillAppear(animated: Bool) {
        //hide the stop button
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeRecordingButton.hidden = true
        
        recordButton.enabled = true
        
        recordingLabel.hidden = false
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
    
    
    @IBAction func recordAudio(sender: UIButton) {
    
        // recordingLabel.hidden = false
        recordingLabel.text = "recording"
        stopButton.hidden = false
        pauseButton.hidden = false
        
        recordButton.enabled = false
      
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        session.setActive(true, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if(flag){
            recordedAudio = RecordedAudio(filePathUrlTemp: recorder.url, titleTemp: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
  
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func pauseRecording(sender: UIButton) {
        
        audioRecorder.pause()
        pauseButton.hidden = true
        recordingLabel.text = "Recording paused. Press red button to resume."
        resumeRecordingButton.hidden = false
        
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        
        audioRecorder.record()
        resumeRecordingButton.hidden = true
        pauseButton.hidden = false
        recordingLabel.text = "recording"
        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        
        recordingLabel.hidden = true
        audioRecorder.stop()
        
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

}

