//
//  ViewController.swift
//  Spotboarding
//
//  Created by Alex on 06/04/2020.
//  Copyright © 2020 tonezone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var folderButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var mainButton: UIButton!
    
    var barElements: [UIBarButtonItem] {
        [infoButton, folderButton, addButton]
    }
    
    var elements: [UIView] {
        [textField, switchView, slider, stepper, spinner, mainButton]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentSpotboarding()
    }
    
    private func presentSpotboarding() {
        let scrFrame = UIScreen.main.bounds
        
        // Get all frames relative to root view controller.
        var spotFrames: [CGRect] = []
        spotFrames += barElements.map { $0.spotFrame }
        spotFrames += elements.map { $0.spotFrame }
    
        let spotboarding = Spotboarding(frame: scrFrame, frames: spotFrames)
        view.root?.addSubview(spotboarding)
        spotboarding.start()
    }
}

