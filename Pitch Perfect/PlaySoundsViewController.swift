//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ryan Harvey on 6/14/15.
//  Copyright © 2015 datascientist.guru. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    var audioEngine: AVAudioEngine!
    var receivedAudio: RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithEffect(pitch pitch: Float? = nil, rate: Float? = nil) {
        audioEngine.stop()
        audioEngine.reset()
        let p = pitch ?? 1.0
        let r = rate ?? 1.0
        guard ClosedInterval(-2400.0, 2400.0).contains(p)
            else { return }
        guard ClosedInterval(1.0/32.0, 32.0).contains(r)
            else { return }
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let audioEffect = AVAudioUnitTimePitch()
        audioEffect.pitch = p
        audioEffect.rate = r
        audioEngine.attachNode(audioEffect)
        
        audioEngine.connect(audioPlayerNode, to:audioEffect, format: nil)
        audioEngine.connect(audioEffect, to:audioEngine.outputNode, format: nil)
        
        do {
            let file = try AVAudioFile(forReading: receivedAudio.filePathUrl)
            audioPlayerNode.scheduleFile(file, atTime: nil, completionHandler: nil)
            try audioEngine.start()
            audioPlayerNode.play()
        } catch {
            print("Error playing audio file")
        }
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithEffect(rate: 0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithEffect(rate: 2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithEffect(pitch: 1000.0)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithEffect(pitch: -1000.0)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
    }
}
