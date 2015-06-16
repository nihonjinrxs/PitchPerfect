//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ryan Harvey on 6/14/15.
//  Copyright © 2015 datascientist.guru. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButtonLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var currentState:RecordingStates = .Ready

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        currentState = .Ready
        setButtonsForState(currentState)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum RecordingStates {
        case Ready, Recording, Paused
    }
    
    func setButtonsForState(state:RecordingStates) {
        switch state {
        case .Ready:
            stopButton.enabled = false
            stopButton.hidden = true
            recordButton.enabled = true
            recordButton.hidden = false
            pauseButton.enabled = false
            pauseButton.hidden = true
            recordButtonLabel.text = "Tap to Record"
            recordButtonLabel.hidden = false
        case .Recording:
            stopButton.enabled = true
            stopButton.hidden = false
            recordButton.enabled = false
            recordButton.hidden = true
            pauseButton.enabled = true
            pauseButton.hidden = false
            recordButtonLabel.text = "Recording Audio..."
            recordButtonLabel.hidden = false
        case .Paused:
            stopButton.enabled = true
            stopButton.hidden = false
            recordButton.enabled = true
            recordButton.hidden = false
            pauseButton.enabled = false
            pauseButton.hidden = true
            recordButtonLabel.text = "Recording Paused..."
            recordButtonLabel.hidden = false
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url,
                withTitle: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording not successful")
            currentState = .Ready
            setButtonsForState(currentState)
       }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        currentState = .Ready
        setButtonsForState(.Ready)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            print("Error inactivating audio session.")
        }
    }
    
    func startNewRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
            print("error setting category of audio session")
            setButtonsForState(.Ready)
        }
        
        do {
            audioRecorder = try AVAudioRecorder(URL: filePath!, settings: [String:AnyObject]())
            audioRecorder.meteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print("Couldn't record audio")
            setButtonsForState(.Ready)
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        switch currentState {
        case .Paused:
            currentState = .Recording
            setButtonsForState(currentState)
            audioRecorder.record()
        case .Ready:
            currentState = .Recording
            setButtonsForState(currentState)
            startNewRecording()
        case .Recording:
            print("Already recording...")
        }
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        currentState = .Paused
        setButtonsForState(currentState)
        audioRecorder.pause()
    }
}

