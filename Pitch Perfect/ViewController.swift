//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Ivan & Aleksandra Kodrnja on 06/03/15.
//  Copyright (c) 2015 2plus2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    override func viewWillAppear(animated: Bool) {
        //hide the stop button
        stopButton.hidden = true
        
        recordButton.enabled = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        recordingLabel.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordAudio(sender: UIButton) {
    
        recordingLabel.hidden = false
        
        stopButton.hidden = false
        
        recordButton.enabled = false
        
        // recordingLabel.hidden =  recordingLabel.hidden ? false : true
        
        /*
        if(recordingLabel.hidden){
            recordingLabel.hidden = false
        }else{
            recordingLabel.hidden = true
        }
        */
        
        //TODO: Record the users's voice
        
    
    }
    
  
    @IBAction func stopAudio(sender: UIButton) {
        
        recordingLabel.hidden = true
    }

}

