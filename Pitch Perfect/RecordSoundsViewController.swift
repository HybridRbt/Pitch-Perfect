//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jianfeng Yang on 1/27/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordingPaused = false
    
    enum Text: String {
        case whenNotRecording = "Press the microphone to start recording."
        case whenRecording = "Recording..."
        case recordedSuccess = "Recording is done!"
        case pausedRecording = "Recording is paused."
    }
    
    enum RecordingStatus {
        case isRecording
        case stoppedRecording
        case pausedRecording
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseResumeButton.hidden = true
        recordButton.enabled = true
        recordingStatus.text = Text.whenNotRecording.rawValue
        recordingPaused = false
    }
    
    /**
     Set the image on the pause/resume button according to current recording state
     
     - parameter paused: indicate if the recording is paused
     */
    func setPauseImageOnPauseResumeButton(paused: Bool) {
        if (paused) {
            //set resume image
            if let resumeImage = UIImage(named:"Resume") as UIImage! {
                pauseResumeButton.setImage(resumeImage, forState: UIControlState.Normal)
            } else {
                print("pic not found!")
            }
        } else {
            //set pause image
            if let pauseImage = UIImage(named:"Pause") as UIImage! {
                pauseResumeButton.setImage(pauseImage, forState: UIControlState.Normal)
            } else {
                print("pic not found!")
            }
        }
    }
    
    func setUI(status: RecordingStatus) {
        switch status {
        case RecordingStatus.isRecording:
            print("in recordAudio...")
            recordingStatus.text = Text.whenRecording.rawValue
            stopButton.hidden = false
            pauseResumeButton.hidden = false
            recordButton.enabled = false
            setPauseImageOnPauseResumeButton(false)
        case RecordingStatus.stoppedRecording:
            print("stop recording...")
            recordingStatus.text = Text.recordedSuccess.rawValue
            recordButton.enabled = true
            stopButton.hidden = true
            pauseResumeButton.hidden = true
            setPauseImageOnPauseResumeButton(false)
        case RecordingStatus.pausedRecording:
            recordingStatus.text = Text.pausedRecording.rawValue
            setPauseImageOnPauseResumeButton(true)
        }
    }
    
    /**
     Create audio file path for audio recorder
     
     - returns: NSURL object
     */
    func setupURLForAudioRecorder() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        return filePath!
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording failed.")
            setUI(RecordingStatus.stoppedRecording)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        //TODO: record the user's voice
        setUI(RecordingStatus.isRecording)
        
        let filePath = setupURLForAudioRecorder()
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        setUI(RecordingStatus.stoppedRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    @IBAction func pauseResumeRecording(sender: UIButton) {
        if (recordingPaused) {
            //resume recording
            setUI(RecordingStatus.isRecording)
            audioRecorder.record()
            recordingPaused = false
        } else {
            //pause recording
            setUI(RecordingStatus.pausedRecording)
            audioRecorder.pause()
            recordingPaused = true
        }
    }
    
}

