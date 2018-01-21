//
//  ViewController.swift
//  GunAR
//
//  Created by Tanishq Kancharla on 1/9/18.
//  Copyright © 2018 Tanishq Kancharla. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

//The cropping rectangle. Centered on the image center, with size 50x50
let cropRect = CGRect(x: 160*10-25, y: 193*9-25, width: 100, height: 100)


//initialization for the getColors method for imageShot
var imageShotColors = UIImageColors(background: UIColor.black, primary: UIColor.white, secondary: UIColor.black, detail: UIColor.black)

//the colors list defined in ColorsList.swift.
let testColors = colorList
//Creating HSB values for the ColorsList and the imageShot to compare them
var hueTest: CGFloat = 0
var saturationTest: CGFloat = 0
var brightnessTest: CGFloat = 0
var alphaTest: CGFloat = 0

var hueIS: CGFloat = 0
var saturationIS: CGFloat = 0
var brightnessIS: CGFloat = 0
var alphaIS: CGFloat = 0

var imageShot : UIImage!
var imageData: Data!

var score: Int = 0

var numberOfPlayers: Int = 0
var testShots = numberOfPlayers
var testColor: UIColor!

//Takes the picture and runs imageShotGetColors to determine whether you shot correctly
extension UIViewController: AVCapturePhotoCaptureDelegate{
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        imageData = photo.fileDataRepresentation()
        imageShot = UIImage(data: imageData)
        imageShot = crop(image: imageShot, cropRect: cropRect)
        imageShotGetColors(imageShot: imageShot)
    }
}


extension UIViewController{
    //gets the colors from imageShot to compare it to the test colors
    func imageShotGetColors(imageShot: UIImage){
        imageShotColors = imageShot.getColors()
        
    }
    func testCloseEnough() {
        
        for color in 0...colorList.count-1{
            if isCloseEnough(index: color, color: imageShotColors.primary) {
                updateScore()
                
                break
                
            }
            
            if isCloseEnough(index: color, color: imageShotColors.background) {
                updateScore()
                
                break
            }
            
        }
    }
    //Tests if the test colors are close enough by comparing hue, saturation, then brightness. Returns true if they match.
func isCloseEnough(index: Int!, color: UIColor!) -> Bool{
        colorList[index].getHue(&hueTest, saturation: &saturationTest, brightness: &brightnessTest, alpha: &alphaTest)
        color.getHue(&hueIS, saturation: &saturationIS, brightness: &brightnessIS, alpha: &alphaIS)
        if(abs(hueTest-hueIS) < 0.1){
            if(abs(saturationIS-saturationTest) < 0.4){
                if(abs(brightnessIS-brightnessTest) < 0.7){
                    return true
                }
                else {
                    return false
                }
            }
            else{
                return false
            }
        }
        else{
            return false
        }
    }
    //the cropping function
    func crop(image:UIImage, cropRect:CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(cropRect.size, false, image.scale)
        let origin = CGPoint(x: cropRect.origin.x * CGFloat(-1), y: cropRect.origin.y * CGFloat(-1))
        image.draw(at: origin)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return result
    }
    
    
    //The updateScore function. Called when the primary or background color matches the test color, meaning you shot something
    func updateScore(){
        //10 added to score when colors match
        score = score + 10
    }
}




class CameraSceneViewController: UIViewController, CBPeripheralManagerDelegate{
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
    }
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    
    @IBOutlet var testButtonPress: UITapGestureRecognizer!
    @IBOutlet var shotButtonPress: UITapGestureRecognizer!
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageShotView1: UIImageView!
    @IBOutlet weak var imageShotView2: UIImageView!
    @IBOutlet weak var previewView: UIView!
    
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var confirmButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let captureDevice = AVCaptureDevice.default(for : AVMediaType.video)

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object
            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = AVCaptureSession.Preset.photo
            
            // Set the input device on the capture session
            captureSession?.addInput(input)
            
            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            // Set the output on the capture session
            captureSession?.addOutput(capturePhotoOutput!)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the input device
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            
            //Initialise the video preview layer and add it as a sublayer to the viewPreview view's layer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            videoPreviewLayer?.frame = previewView.layer.bounds
            previewView.layer.addSublayer(videoPreviewLayer!)
            
            //start video capture
            captureSession?.startRunning()
            
            
        } catch {
            print(error)
            return
        }
        
        //capturePhotoOutput?.capturePhoto(with: settings1, delegate: self)
        scoreLabel.isHidden = true
        confirmButton.isHidden = true
        confirmButton2.isHidden = true
        shotButtonPress.isEnabled = false
        testButtonPress.isEnabled = true
        let settings2 = AVCapturePhotoSettings()
        capturePhotoOutput?.capturePhoto(with: settings2, delegate: self)
    }
    
    
    
    //When the button gets pressed. For now, it's connnected to a gesture recognizer for the previewView

    
    @IBAction func testButtonPressed(_ sender: Any) {
        //You first shoot test shots to determine the targets and colorList
        let settings1 = AVCapturePhotoSettings()
        capturePhotoOutput?.capturePhoto(with: settings1, delegate: self)
        if(testShots > 1){
            
            imageShotView1.backgroundColor = imageShotColors.primary
            imageShotView2.backgroundColor = imageShotColors.background
            scoreLabel.isHidden = false
            confirmButton.isHidden = false
            confirmButton2.isHidden = false
        }
        else{
            imageShotView1.isHidden = true
            imageShotView2.isHidden = true
            testButtonPress.isEnabled = false
            shotButtonPress.isEnabled = true
            scoreLabel.text = "Shoot!"
            
        }
        
    }
    
    //When the characteristic's value gets updated, it runs this function, which simulates a screen press
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
       
            self.testButtonPressed((Any).self)
            self.shotButtonPressed((Any).self)
        
        
    }
    //After the test shots to determine player colors have been determined, it reverts to shot button pressing
    
    @IBAction func shotButtonPressed(_ sender: Any) {
        
        let settings2 = AVCapturePhotoSettings()
        capturePhotoOutput?.capturePhoto(with: settings2, delegate: self)
        testCloseEnough()
        confirmButton.isHidden = true
        confirmButton2.isHidden = true
        imageShotView1.image = imageShot
        scoreLabel.text = "Score: \(score)"
    }
    
    //When the confirm label for color one is pressed, it adds it to colorList
    @IBAction func confirmPlayerColor1Pressed(_ sender: Any) {
        colorList.append(imageShotColors.primary)
        testShots = testShots - 1
        scoreLabel.text="Added!"
        confirmButton.isHidden = true
        confirmButton2.isHidden = true
    }
    //When the confirm label for color two is pressed, it adds it to colorList
    @IBAction func confirmPlayerColor2Pressed(_ sender: Any) {
        colorList.append(imageShotColors.background)
        testShots = testShots - 1
        scoreLabel.text="Added!"
        confirmButton.isHidden = true
        confirmButton2.isHidden = true
    }
    
    
    
}

