//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jianfeng Yang on 1/29/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAudioEngineAndAudioFile()
        initAudioPlayer()
    }

    func initAudioPlayer() {
//        if let fileURL = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3") {
//            try! audioPlayer = AVAudioPlayer(contentsOfURL: fileURL)
//            audioPlayer.stop()
//            audioPlayer.enableRate = true
//        }
//        else {
//            print("File not Found!")
//        }
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.stop()
        audioPlayer.enableRate = true
    }
    
    func initAudioEngineAndAudioFile() {
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    func resetAudioPlayer() {
        audioPlayer.currentTime = 0.0
    }
    
    func playAudio(rate: Float) {
        resetAudioPlayer()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(2.0)
    }
    
    @IBAction func stopPlayAudio(sender: UIButton) {
        audioPlayer.stop()
        resetAudioPlayer()
    }
    
    func stopAllAudio() {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
    }
    
    func prepareAudioEngineForPitchChanging(pitch: Float) -> AVAudioPlayerNode {
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(audioPlayerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        return audioPlayerNode
    }
    
    func prepareAudioEngineForTimeDelay(time: NSTimeInterval) -> AVAudioPlayerNode {
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let delay = AVAudioUnitDelay()
        delay.delayTime = time
        audioEngine.attachNode(delay)
        
        audioEngine.connect(audioPlayerNode, to: delay, format: nil)
        audioEngine.connect(delay, to: audioEngine.outputNode, format: nil)
        
        return audioPlayerNode
    }
    
    func playAudioFileWithVariablePitch(file: AVAudioFile, pitch: Float) {
        stopAllAudio()
        let audioPlayerNode = prepareAudioEngineForPitchChanging(pitch)
        audioPlayerNode.scheduleFile(file, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    func playAudioFileWithDelayedFeedback(file: AVAudioFile, delayTime: NSTimeInterval) {
        stopAllAudio()
        let audioPlayerNode = prepareAudioEngineForTimeDelay(delayTime)
        audioPlayerNode.scheduleFile(file, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        let chipmunkPitch = 1000 as Float
        playAudioFileWithVariablePitch(audioFile, pitch: chipmunkPitch)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        let darthVaderPitch = -1000 as Float
        playAudioFileWithVariablePitch(audioFile, pitch: darthVaderPitch)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
