//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jianfeng Yang on 1/29/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var slowSpeedButton: UIButton!
    @IBOutlet weak var fastSpeedButton: UIButton!
    @IBOutlet weak var chipMunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopPlayAudioButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAudioEngineAndAudioFile()
        initAudioPlayer()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopPlayAudioButton.hidden = true
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
        audioPlayer.delegate = self
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        enableDisableAllButtons(true)
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
    
    func stopAllAudio() {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
    }
    
    func connectSoundEffectToPlayer(effect: AVAudioNode) -> AVAudioPlayerNode {
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        return audioPlayerNode
    }
    
    func prepareAudioEngineForPitchChanging(pitch: Float) -> AVAudioPlayerNode {
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        return connectSoundEffectToPlayer(timePitch)
    }
    
    func prepareAudioEngineForEcho(time: NSTimeInterval) -> AVAudioPlayerNode {
        let delay = AVAudioUnitDelay()
        delay.delayTime = time
        
        return connectSoundEffectToPlayer(delay)
    }
    
    func prepareAudioEngineForReverb(preset: AVAudioUnitReverbPreset) -> AVAudioPlayerNode {
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(preset)
        
        return connectSoundEffectToPlayer(reverb)
    }
    
    func playMixedFile(playerNode: AVAudioPlayerNode, file: AVAudioFile) {
        stopAllAudio()
        playerNode.scheduleFile(file, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        playerNode.play()
    }
    
    func playAudioFileWithVariablePitch(audioFile: AVAudioFile, pitch: Float) {
        let audioPlayerNode = prepareAudioEngineForPitchChanging(pitch)
        playMixedFile(audioPlayerNode, file: audioFile)
    }
    
    func playAudioFileWithEcho(audioFile: AVAudioFile, delayTime: NSTimeInterval) {
        let audioPlayerNode = prepareAudioEngineForEcho(delayTime)
        playMixedFile(audioPlayerNode, file: audioFile)
    }
    
    func playAudioFileWithReverb(audioFile: AVAudioFile, presetEffect: AVAudioUnitReverbPreset) {
        let audioPlayerNode = prepareAudioEngineForReverb(presetEffect)
        playMixedFile(audioPlayerNode, file: audioFile)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudio(0.5)
        enableDisableAllButtons(false)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudio(2.0)
        enableDisableAllButtons(false)
    }
    
    @IBAction func stopPlayAudio(sender: UIButton) {
        audioPlayer.stop()
        resetAudioPlayer()
        enableDisableAllButtons(true)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        let chipmunkPitch = 1000 as Float
        playAudioFileWithVariablePitch(audioFile, pitch: chipmunkPitch)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        let darthVaderPitch = -1000 as Float
        playAudioFileWithVariablePitch(audioFile, pitch: darthVaderPitch)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let time = 1 as NSTimeInterval
        playAudioFileWithEcho(audioFile, delayTime: time)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let effect = AVAudioUnitReverbPreset.LargeRoom
        playAudioFileWithReverb(audioFile, presetEffect: effect)
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
