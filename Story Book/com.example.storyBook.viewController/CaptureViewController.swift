//
//  CaptureViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/29/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit
import AVFoundation

protocol CapturedManagerDelegate {
    
    func hiddenPreviewImage()
    
}

class CaptureViewController: UIViewController {

    @IBOutlet weak var camPreview: UIView!
    @IBOutlet weak var cameraRotateButton: UIButton!
    @IBOutlet weak var flashModeButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var cuptureViewTitle: UILabel!
    @IBOutlet weak var cupturePhotoButton: UIButton!
    @IBOutlet weak var cuptureVideoButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var captureTmeLabel: UILabel!
    @IBOutlet weak var videoRecodingImage: UIImageView!
    
    // Language Localization
    public var localizResouce : String?
    
    //Flash Light
    private let flashLightList : [String] = ["on","auto","off"]
    
    private var flashLightLoopIndex = Int()
    private var flashLightIndex = Int()
    
    //Camera & Video
    public let captureSession = AVCaptureSession()
    
    private var photoOutput = AVCapturePhotoOutput()
    
    private var activeInput: AVCaptureDeviceInput!
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private var isSessionSetup = false
    
    private var capturedImage: Data?
    
    public var currentPosition : AVCaptureDevice.Position = .back
    
    private let movieOutput = AVCaptureMovieFileOutput()
    
    private var outputURL : URL!
    
    private var recodedVideoURL : URL?
    
    // Timer
    private var timer = Timer()
    
    private var captuteTime = 0
    
    private var dateFormatter = DateFormatter()
    
    public var addStoryVC : AddStoryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let languageResouce = localizResouce {
            
            setLanguageLocalization(languageResouce)
            
        }
        
        
        // add cornerradius in UIButton
        cameraRotateButton.layer.cornerRadius = cameraRotateButton.frame.width / 2
        flashModeButton.layer.cornerRadius = flashModeButton.frame.width / 2
        captureButton.layer.cornerRadius = captureButton.frame.width / 2
        videoRecodingImage.layer.cornerRadius = videoRecodingImage.frame.width / 2
        
        nextButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isSessionSetup {
            if cuptureViewTitle.text!.elementsEqual("Photo") || cuptureViewTitle.text!.elementsEqual("ඡායාරූප"){
                if setupPhotoSession() {
                    
                    setupPreview()
                    
                    startSession()
                    
                }
            } else {
                if setupVideoSession() {
                    
                    setupPreview()
                    
                    startSession()
                    
                }
            }
        }
        else {
            if !captureSession.isRunning {
                
                startSession()
                
            }
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession.isRunning {
            
            stopSession()
            
        }
        
        nextButton.isEnabled = false
    }
    
    private func startSession() {
        
        DispatchQueue.main.async {
            
            self.captureSession.startRunning()
            
        }
        
    }
    
    private func stopSession() {
        
        DispatchQueue.main.async {
            
            self.captureSession.stopRunning()
            
        }
        
    }
    
    private func setupPhotoSession() -> Bool {
        
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: currentPosition)!
            
            let input = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(input) {
                
                captureSession.addInput(input)
    
                activeInput = input
                
            } else {
                print("was not able to add input device")
                
                captureSession.commitConfiguration()
                
                return false
                
            }
            
        } catch {
            
            print("was not able to add input device")
            
            captureSession.commitConfiguration()
            
            return false
            
        }
        
        if captureSession.canAddOutput(photoOutput) {
            
            captureSession.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            
        }
        else {
            
            print("failed to create photo output")
            
            captureSession.commitConfiguration()
            
            return false
            
        }
        
        captureSession.commitConfiguration()
        
        isSessionSetup = true
        
        return true
        
    }
    
    private func setupVideoSession() -> Bool{
        
        captureSession.beginConfiguration()
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentPosition) else {return false}
        
        guard let audio = AVCaptureDevice.default(for: .audio) else {return false}
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        do{
            let input = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(input){
                
                captureSession.addInput(input)
                
                activeInput = input
                
            } else {
                print("was not able to add input.")
                
                captureSession.commitConfiguration()
                
                return false
            }
            
        } catch {
            
            print("could not get camera device input.")
            
            captureSession.commitConfiguration()
            
            return false
            
        }
        
        do {
            let micInput = try AVCaptureDeviceInput(device: audio)
            
            if captureSession.canAddInput(micInput){
                
                captureSession.addInput(micInput)
                
            } else {
                
                print("was not able add mic device input")
                
                captureSession.commitConfiguration()
                
            }
        } catch {
            captureSession.commitConfiguration()
            
            return false
        }
        
        
        if captureSession.canAddOutput(movieOutput){
            
            captureSession.addOutput(movieOutput)
            
        } else {
            
            print("was not able to add output")
            
            captureSession.commitConfiguration()
            
            return false
        }
        
        isSessionSetup = true
        
        captureSession.commitConfiguration()
        
        return true
    }
    
    private func setupPreview() {
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = camPreview.bounds
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        camPreview.layer.addSublayer(previewLayer)
        
    }
    
    private func tempURL() -> URL?{
        
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    private func startRecoding(){
        
        if !movieOutput.isRecording{
            
            outputURL = tempURL()
            
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
            captureButton.backgroundColor = UIColor.blue
            
        } else {
            stopRecoding()
        }
    }
    
    private func stopRecoding(){
        if movieOutput.isRecording {
            
            movieOutput.stopRecording()
            
            captureButton.backgroundColor = UIColor.red
        }
    }

    
    @IBAction func typeOfMediaButtonDidTouch(_ sender: UIButton) {
        if sender.currentTitle!.elementsEqual("Photo") ||  sender.currentTitle!.elementsEqual("ඡායාරූප"),let languageResouce = localizResouce{
            cuptureViewTitle.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TITLE_PHOTO")
            flashModeButton.isHidden = false
            captureTmeLabel.isHidden = true
            videoRecodingImage.isHidden = true
            captureButton.setImage(UIImage(named: "Capture_Photo_Button"), for: .normal)
            cupturePhotoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
            cuptureVideoButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: UIFont.buttonFontSize)
            
            captureSession.removeInput(activeInput)
            captureSession.removeOutput(photoOutput)
            
            let _ = setupPhotoSession()
            
        } else if let languageResouce = localizResouce {
            cuptureViewTitle.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TITLE_VIDEO")
            flashModeButton.isHidden = true
            captureTmeLabel.isHidden = false
            videoRecodingImage.isHidden = false
            captureButton.setImage(UIImage(named: "Capture _Video_Icon"), for: .normal)
            cuptureVideoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
            cupturePhotoButton.titleLabel?.font = UIFont.italicSystemFont(ofSize: UIFont.buttonFontSize)
            
            captureSession.removeInput(activeInput)
            captureSession.removeOutput(photoOutput)
            
            let _ = setupVideoSession()
        }
    }
    
    
    
    
    @IBAction func captureButtonDidTouch(_ sender: UIButton) {
        if cuptureViewTitle.text!.elementsEqual("Photo") || cuptureViewTitle.text!.elementsEqual("ඡායාරූප"){
            capturedPhotoDidTouch()
        } else {
            startRecoding()
        }
    }
    
    
    @IBAction func flashLightButtonDidTouch(_ sender: UIButton) {
        
        switch flashLightLoopIndex {
        case 0 :
            flashModeButton.setImage(UIImage(named: "FlashLight_On_Icon"), for: .normal)
            flashLightLoopIndex += 1
            flashLightIndex = 0
            break
        case 1 :
            flashModeButton.setImage(UIImage(named: "FlashLight_Auto_Icon"), for: .normal)
            flashLightLoopIndex += 1
            flashLightIndex = 1
            break
        case 2 :
            flashModeButton.setImage(UIImage(named: "FlashLight_Off_Icon"), for: .normal)
            flashLightLoopIndex = 0
            flashLightIndex = 2
            break
        default:
            break
        }
    }
    
    @IBAction func rotateCameraButton(_ sender: UIButton) {
        if cuptureViewTitle.text!.elementsEqual("Photo") || cuptureViewTitle.text!.elementsEqual("ඡායාරූප"){

            captureSession.removeInput(activeInput)
            captureSession.removeOutput(photoOutput)

            if currentPosition == .front{
                currentPosition = .back
            } else {
                currentPosition = .front
            }
            let _ = setupPhotoSession()

        } else {
            captureSession.removeInput(activeInput)
            captureSession.removeOutput(photoOutput)

            if currentPosition == .front{
                currentPosition = .back
            } else {
                currentPosition = .front
            }
            let _ = setupVideoSession()
        }
    }
    
    @IBAction func nextButtonDidTouch(_ sender: Any) {
        
        if addStoryVC == nil{
            
            if let languageResouce = localizResouce{
                
                let senderCapture : (Data?,URL?,String) = (capturedImage,recodedVideoURL,languageResouce)
                
                performSegue(withIdentifier: "CAPTUREDSEGUE", sender: senderCapture)
                
            }
            
        } else {
            
            let storyPostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StoryPostVC") as! StoryPostViewController
            
            storyPostVC.localizationResouce = localizResouce
            
            storyPostVC.storyImageData = capturedImage
            
            self.present(storyPostVC, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func cancelButtonDidTouch(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    private func setLanguageLocalization(_ languageResouce : String){
        
        cancelButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CANCEL_BUTTON"), for: .normal)
        
        nextButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "NEXT_BUTTON"), for: .normal)
        
        cuptureViewTitle.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TITLE_PHOTO")
        
        cupturePhotoButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TITLE_PHOTO"), for: .normal)
        
        cuptureVideoButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TITLE_VIDEO"), for: .normal)
        
    }
    
    private func capturedPhotoDidTouch(){
        let photoSettings = AVCapturePhotoSettings()
        
        if activeInput.device.isFlashAvailable{
            switch flashLightIndex {
            
            case 0:
                photoSettings.flashMode = .on
                
                break
            
            case 1:
                photoSettings.flashMode = .auto
                
                break
            case 2:
                photoSettings.flashMode = .off
                
                break
                    
            default:
                break
            }
            
        }
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    @objc private func timerAction(){
        videoRecodingImage.isHidden = false
        captuteTime += 1
        
        let hours = Int(captuteTime) / 3600
        let minutes = Int(captuteTime) / 60 % 60
        let seconds = Int(captuteTime) % 60

        captureTmeLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CAPTUREDSEGUE"{
            guard let destination = segue.destination as? NewPostViewController else {return}
            
            guard let captured = sender as? (Data?,URL?,String) else {return}
            
            if cuptureViewTitle.text!.elementsEqual("Photo") ||  cuptureViewTitle.text!.elementsEqual("ඡායාරූප"){
                
                destination.capturedImage = captured.0
                
            } else {
                
                destination.capturedVideo = captured.1
                
            }
            
            destination.localizResoce = captured.2
            
            destination.capturedDelegate = self
            
        }
    }
    
}

//Mark :- AVCapturePhotoCaptureDelegate
extension CaptureViewController : AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard error == nil else {
            
            print("Error in capture process: \(String(describing: error))")
            
            return
            
        }
        
        guard let imageData = photo.fileDataRepresentation() else {
            
            print("Unable tp create image data")
            
            return
            
        }
        
        capturedImage = imageData
        
        previewImage.image = UIImage(data: imageData)
        
        nextButton.isEnabled = true
    }
}

//Mark :- AVCaptureFileOutputRecordingDelegate
extension CaptureViewController : AVCaptureFileOutputRecordingDelegate {
    
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        if let getError = error {
            
            print("Error video recoding : \(getError.localizedDescription)")
            
            return
        } else {
            
            let videoRecoded = outputURL as URL
            
            if let tambnail = videoRecoded.makeThumbnail(){
                
                previewImage.image = tambnail
                //thumbnailButton.setBackgroundImage(tambnail, for: .normal)
            }
            
            self.recodedVideoURL = videoRecoded

            timer.invalidate()
            
            captuteTime = 0
            
            captureTmeLabel.text = "00:00:00"
            
            nextButton.isEnabled = true
        }
    }
}

extension URL {
    
    func makeThumbnail() -> UIImage? {
        
        do {
            let asset = AVURLAsset(url: self, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
            
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
        return nil
        
    }
}

extension CaptureViewController : CapturedManagerDelegate{
    
    func hiddenPreviewImage() {
        
        self.previewImage.image = nil
        
    }
}
