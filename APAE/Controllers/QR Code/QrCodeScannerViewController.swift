//
//  QrCodeScannerViewController.swift
//  APAE
//
//  Created by Rui Costa on 03/02/2022.
//

import Foundation
import UIKit
import AVFoundation
import SafariServices

class QrCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    static let identifier = "QrCodeScannerViewController"
    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating session
        let session = AVCaptureSession()
        
        //Define capture device
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch{
            print("error")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
   
        
        view.layer.addSublayer(video)
        self.view.bringSubviewToFront(qrImage)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects != nil && metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr{
                    let url = URL(string: object.stringValue!)
                    
                    let alert = UIAlertController(title: "QR APAE", message: "Deseja abrir a noticia ?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Abrir", style: .default, handler: { (nil) in
                        let vc = SFSafariViewController(url: url!)
                        self.present(vc, animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
}
