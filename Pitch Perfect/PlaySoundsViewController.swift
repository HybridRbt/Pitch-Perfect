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
    
    func resetAudioPlayerAndAudioEngine() {
        audioPlayer.currentTime = 0.0
        audioEngine.reset()
    }
    
    func playAudio(rate: Float) {
        resetAudioPlayerAndAudioEngine()
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
    
    func enableDisableAllButtons(enabled: Bool) {
        slowSpeedButton.enabled = enabled
        fastSpeedButton.enabled = enabled
        chipMunkButton.enabled = enabled
        darthVaderButton.enabled = enabled
        echoButton.enabled = enabled
        reverbButton.enabled = enabled
        
        if (enabled) {
            //no stop button shown
            stopPlayAudioButton.hidden = true
        } else {
            //show stop button when playing
            stopPlayAudioButton.hidden = false
        }
    }
    
    /**
     Called after audio player node has finished playing
     */
    func playerFinished() {
        stopAllAudio()
        enableDisableAllButtons(true)
    }
    
    func connectSoundEffectToPlayer(effect: AVAudioNode) -> AVAudioPlayerNode {
        initAudioEngineAndAudioFile()
        
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
        let buffer = AVAudioPCMBuffer(PCMFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))
        try! file.readIntoBuffer(buffer)
        playerNode.scheduleBuffer(buffer, completionHandler: playerFinished)
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
        resetAudioPlayerAndAudioEngine()
        enableDisableAllButtons(true)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        let chipmunkPitch = 1000 as Float
        enableDisableAllButtons(false)
        playAudioFileWithVariablePitch(audioFile, pitch: chipmunkPitch)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        let darthVaderPitch = -1000 as Float
        enableDisableAllButtons(false)
        playAudioFileWithVariablePitch(audioFile, pitch: darthVaderPitch)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        let time = 1 as NSTimeInterval
        enableDisableAllButtons(false)
        playAudioFileWithEcho(audioFile, delayTime: time)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        let effect = AVAudioUnitReverbPreset.LargeRoom
        enableDisableAllButtons(false)
        playAudioFileWithReverb(audioFile, presetEffect: effect)
    }
}
