//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Nicolai Guldbæk Holst on 22/04/2017.
//  Copyright © 2017 Just Code ApS. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder : AVAudioRecorder!

    
    @IBAction func recordAudio(_ sender: AnyObject) {
        recordingLabel.text = "Recording in progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording failed")
        }
    }
    
    func setRecordingEnabled(enabled : Bool){
        stopRecordingButton.isEnabled = enabled;
        recordButton.isEnabled = !enabled
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setRecordingEnabled(enabled: false)
    }


    @IBAction func stopRecording(_ sender: Any) {
        recordingLabel.text = "Tab to record"
        setRecordingEnabled(enabled: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            
            let playSoundsVC = segue.destination as! PlaySoundsViewController
        let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL}
    }
    
}

