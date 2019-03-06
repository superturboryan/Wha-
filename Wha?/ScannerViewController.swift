//
//  ScannerViewController.swift
//  Wha?
//
//  Created by Ryan David Forsyth on 2019-03-05.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ScannerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - IBOutlets and variables
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultsTextView: UITextView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let alertController = UIAlertController.init(title: nil, message: "Device has no camera.", preferredStyle: .alert)
            
            let okAction = UIAlertAction.init(title: "Alright", style: .default, handler: {(alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        imageView.layer.cornerRadius = CGFloat(7)
        resultsTextView.layer.cornerRadius = CGFloat(7)
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            guard let coreImageImage = CIImage(image: userPickedImage) else {fatalError("Could not convert UIImage to CIImage!")}
            
            detect(image: coreImageImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image : CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("Could not load CoreML model!")}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {fatalError("Model failed to process image!")}
            
            let firstResultID = results[0].identifier
            let secondResultID = results[1].identifier
            let thirdResultID = results[2].identifier
            
            self.resultsTextView.text = "Here are your scientifically calulated results: \nHmmm... \nFirst guess: \(firstResultID) \nSecond guess: \(secondResultID) \nThird guess: \(thirdResultID)"
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }
        catch{
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func cameraPressed(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    

}
