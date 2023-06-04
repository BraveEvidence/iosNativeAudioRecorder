//
//  ViewController.swift
//  RecordAudioIos
//
//  Created by TransformHub on 02/06/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var player: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        //                        self.activityIndicator.startAnimating()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    
    
    @IBAction func startRecordingClicked(_ sender: Any) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            
        } catch {
        }
    }
    
    
    @IBAction func stopRecordingClicked(_ sender: Any) {
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    
    @IBAction func playClicked(_ sender: Any) {
        
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentsDirectory.appendingPathComponent("recording.m4a")
        
        do {
            player = try AVAudioPlayer(contentsOf: audioFilename)
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    
    
    @IBAction func stopClicked(_ sender: Any) {
        if player != nil {
            player.stop()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

