//
//  MikPaymentCardsOCRViewController.swift
//  MikFoundation
//
//  Created by m7 on 2021/4/19.
//

import UIKit
import Vision
import VisionKit

public class MikPaymentCardsOCRViewController: UIViewController {

    public typealias ConfirmHandler = (CardDetails?) -> Void
    
    public var confirmHandler: ConfirmHandler?
    
    private var paymentsCardEngine = PaymentsCardEngine()
    
    private lazy var documentCameraViewController: VNDocumentCameraViewController = {
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        documentCameraViewController.view.tintColor = UIColor.mik.general(.hex0475BC)
        return documentCameraViewController
    }()
    
    private lazy var textRecognitionRequest: VNRecognizeTextRequest = {
        let vnTextRequest = VNRecognizeTextRequest(completionHandler: { [weak self] (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    DispatchQueue.main.async {
                        let maximumCandidates = 1
                        var cardDetails = CardDetails()
                        
                        for observation in requestResults {
                            guard let candidate = observation.topCandidates(maximumCandidates).first else { continue } // goes to next iteration
                            if let predictionTuple = self?.paymentsCardEngine.parseNormalisedCoordinates(boundingBox: observation.boundingBox, with: candidate.string) {
                              cardDetails[String(describing: predictionTuple.0)] = predictionTuple.1
                            }
                        }
                        
                        MikToast.hideHUD(in: self?.view)
                        self?.dismiss(animated: false) {
                            self?.confirmHandler?(cardDetails)
                        }
                    }
                    
                    return
                }
            }
            
            DispatchQueue.main.async {
                MikToast.hideHUD(in: self?.view)
                self?.dismiss(animated: false) {
                    self?.confirmHandler?(nil)
                }
            }
        })
        
        vnTextRequest.recognitionLevel = .accurate
        vnTextRequest.usesLanguageCorrection = true
        return vnTextRequest
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private
extension MikPaymentCardsOCRViewController {
    
    private func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            MikToast.hideHUD(in: self.view)
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            MikToast.hideHUD(in: self.view)
        }
    }
    
}

// MARK: - Public
public extension MikPaymentCardsOCRViewController {
    
    /// 显示
    func showInViewController(_ viewController: UIViewController) {
        viewController.present(self, animated: false, completion: nil)
        present(self.documentCameraViewController, animated: true, completion: nil)
    }
    
}
 
// MARK: - VNDocumentCameraViewControllerDelegate
extension MikPaymentCardsOCRViewController: VNDocumentCameraViewControllerDelegate {
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) {            
            MikToast.showHUD(in: self.view)
            DispatchQueue.global(qos: .userInitiated).async {
              for pageNumber in 0 ..< scan.pageCount {
                let image = scan.imageOfPage(at: pageNumber)
                self.processImage(image: image)
              }
            }
        }
    }
    
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error){
        controller.dismiss(animated: true) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
