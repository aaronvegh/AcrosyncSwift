//
//  ViewController.swift
//  AcrosyncSwiftExample
//
//  Created by Aaron Vegh on 2019-05-03.
//  Copyright © 2019 Aaron Vegh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var acrosync: AcrosyncWrapper? = nil
    
    // Server IP address or domain name
    @IBOutlet var serverNameField: UITextField!
    
    // Port on server: 22 for SSH (usually) or whatever you define for rsyncd
    @IBOutlet var portField: UITextField!
    
    // Remote user name for connection
    @IBOutlet var userField: UITextField!
    
    // If using rsync daemon or password SSH (don't do that), user password
    @IBOutlet var passwordField: UITextField!
    
    // Rsyncd module name
    @IBOutlet var moduleField: UITextField!
    
    // SSH Private Key path
    // root ("/") is the Library directory in this implementation
    @IBOutlet var keyPathField: UITextField!
    
    // Remote file path; absolute for SSH; module-relative for rsyncd
    @IBOutlet var remoteField: UITextField!
    
    // In this implementation (see `engageSync()` below),
    // root ("/") is the documents dir on local
    @IBOutlet var localField: UITextField!
    
    // Choose SSH or rsyncd. You should use SSH.
    @IBOutlet var connectViaControl: UISegmentedControl!
    
    // Upload or download
    @IBOutlet var syncDirectionControl: UISegmentedControl!
    
    // Some UI goodness
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var actionButton: UIButton!
    
    
    @IBAction func engageSync(sender: UIButton) {
        // Toggle state of button between Engage and Cancel
        if acrosync == nil {
            // set button to Cancel
            actionButton.setTitle("CANCEL", for: .normal)
            actionButton.backgroundColor = UIColor.red
            
            // This won't work at all without these fields
            guard let serverName    = serverNameField.text,
                  let port          = Int(portField.text ?? "0"),
                  let user          = userField.text,
                  let remotePath    = remoteField.text,
                  let localPath     = localField.text else { return }
            let sshEnabled = connectViaControl.selectedSegmentIndex == 0
            let syncDirection = syncDirectionControl.selectedSegmentIndex == 0 ? SyncDirection.upload : SyncDirection.download
            
            // Fill out the local file path from Documents
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fullLocalPath = documentsURL.appendingPathComponent(localPath).path
            
            // If using private key (you should!), fill out the key path from Library
            var keyPathValue: String?
            if let keyPath = keyPathField.text {
                let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first
                keyPathValue = libraryURL?.appendingPathComponent(keyPath).path
            }
            
            // Initialize the wrapper
            acrosync = AcrosyncWrapper(sshEnabled: sshEnabled, server: serverName, port: port, user: user, password: passwordField.text, module: moduleField.text, keyPath: keyPathValue, syncDirection: syncDirection, remotePath: remotePath, localPath: fullLocalPath)
            
            // Connect our Progress with the wrapper's
            progressView.observedProgress = acrosync?.progress
            
            // Begin sync, with callback when complete.
            acrosync?.execute() { [weak self] in
                self?.cleanup()
            }
        } else {
            cleanup()
        }
        
    }
    
    private func cleanup() {
        actionButton.setTitle("ENGAGE", for: .normal)
        actionButton.backgroundColor = UIColor(red:0.005, green:0.595, blue:0.986, alpha:1.000)
        acrosync?.cancel()
        acrosync = nil
    }
}
