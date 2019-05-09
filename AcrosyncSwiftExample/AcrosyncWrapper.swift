//
//  Acrosync.swift
//  AcrosyncSwiftExample
//
//  Created by Aaron Vegh on 2019-05-03.
//  Copyright © 2019 Aaron Vegh. All rights reserved.
//

import AcrosyncSwift

enum SyncDirection {
    case upload
    case download
}

class AcrosyncWrapper: NSObject {
    
    let wrapper = Acrosync()
    
    var sshEnabled = false
    var server: String
    var port: Int
    var user: String
    var password: String?
    var module: String?
    var keyPath: String?
    var syncDirection: SyncDirection
    var remotePath: String?
    var localPath: String?
    
    var progress: Progress
    var timer: Timer?
    
    init(sshEnabled: Bool, server: String, port: Int, user: String, password: String?, module: String?, keyPath: String?, syncDirection: SyncDirection, remotePath: String, localPath: String) {
        self.sshEnabled = sshEnabled
        self.server = server
        self.port = port
        self.user = user
        self.password = password
        self.module = module
        self.keyPath = keyPath
        self.syncDirection = syncDirection
        self.remotePath = remotePath
        self.localPath = localPath
        
        progress = Progress(totalUnitCount: 1)
    }
    
    func execute(completion: @escaping (() -> Void)) {
        // Initialize the rsync process
        wrapper.startRsync(RsyncLogLevel.LogLevelDebug)
        
        // Set some important properties
        wrapper.remoteDir = remotePath
        wrapper.localDir = localPath
        wrapper.progress = progress
        
        // If true, will delete everything not specified in the backup.
        // i.e. if no includeFiles are set, any file not at source will
        // be deleted at destination. And if includeFiles are set, everything
        // but the includeFiles will be deleted. So be careful, this is very
        // powerful stuff.
        wrapper.deletionEnabled = false
        
        // A timer to allow us to track progress, based on the state of `isSyncing`
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { _ in
            if self.wrapper.isSyncing {
                self.progress.completedUnitCount = self.wrapper.physicalBytes
                self.progress.totalUnitCount = self.wrapper.totalBytes
            } else {
                self.progress.completedUnitCount = 0
                self.progress.totalUnitCount = 0
                self.timer?.invalidate()
                completion()
            }
        })
        
        let isUploading = syncDirection == .upload ? true : false
        
        if sshEnabled {
            wrapper.connect(viaSSH: server, port: Int32(port), user: user, password: password, keyPath: keyPath, isUploading: isUploading, includeFiles: [])
        } else {
            wrapper.connect(viaDaemon: server, port: Int32(port), user: user, password: password, module: module, isUploading: isUploading, includeFiles: [])
        }        
    }
    
    func cancel() {
        wrapper.cancel()
    }
}
