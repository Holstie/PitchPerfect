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
        setUIState(isRecording: true)
        
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
    
    func setUIState(isRecording:Bool)
    {
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        let text = isRecording == true ? "Recording in progress" : "Tap to record"
        recordingLabel.text = text

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUIState(isRecording : false)
    }


    @IBAction func stopRecording(_ sender: Any) {
        setUIState(isRecording: false)
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

