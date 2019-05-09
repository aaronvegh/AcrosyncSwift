//
//  Acrosync.m
//  AcrosyncSwift
//
//  Created by Aaron Vegh on 2019-05-04.
//  Copyright © 2019 Aaron Vegh. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <libssh2.h>
#include <openssl/md5.h>

#include <string>
#include <vector>
#include <set>

#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <sstream>

#import "InternalHeaders.h"
#import "Acrosync.h"

@interface Acrosync ()
@property (readwrite, strong) NSOperationQueue * operationQueue;
@property (readwrite, assign) int g_cancelFlag;
@end

@implementation Acrosync

- (void)startRsync:(RsyncLogLevel)atLogLevel {
    self.g_cancelFlag = 0;
    self.totalBytes = 0;
    self.physicalBytes = 0;
    self.logicalBytes = 0;
    self.skippedBytes = 0;
    
    self.uploadKbps = 512;
    self.downloadKbps = 512;
    self.deletionEnabled = YES;
    
    rsync::SocketUtil::startup();
    rsync::Log::setLevel(atLogLevel);
    
    self.operationQueue = [NSOperationQueue new];
    self.operationQueue.maxConcurrentOperationCount = 1;
}

- (void)connectViaSSH:(NSString *)server port:(int)port user:(NSString *)user password:(NSString*)password keyPath:(NSString*)keyPath isUploading:(BOOL)isUploading includeFiles:(NSArray*)includeFiles {
    
    NSBlockOperation * rsyncOp = [NSBlockOperation blockOperationWithBlock:^{
        try {
            self.g_cancelFlag = 0;
            self.isSyncing = YES;
            int rc = libssh2_init(0);
            if (rc != 0) {
                LOG_ERROR(LIBSSH2_INIT) << "libssh2 initialization failed: " << rc << LOG_END
                return;
            }
            
            rsync::SSHIO sshio;
            const char *s = [server UTF8String];
            const char *u = [user UTF8String];
            const char *pass = [password UTF8String];
            const char *kp = [keyPath UTF8String];
            if (kp != NULL) {
                sshio.connect(s, port, u, 0, kp, 0);
            } else {
                sshio.connect(s, port, u, pass, 0, 0);
            }
            
            rsync::Client client(&sshio, "rsync", 30, &self->_g_cancelFlag);
            client.setSpeedLimits(self.uploadKbps, self.downloadKbps);
            client.setDeletionEnabled(self.deletionEnabled);
            client.setStatsAddresses(&self->_totalBytes, &self->_physicalBytes, &self->_logicalBytes, &self->_skippedBytes);
            
            std::set<std::string> filesToInclude;
            if (isUploading) {
                if (includeFiles.count > 0) {
                    for (NSString * file in includeFiles) {
                        filesToInclude.insert(std::string([file UTF8String]));
                    }
                    client.upload([self.localDir UTF8String], [self.remoteDir UTF8String], &filesToInclude);
                } else {
                    client.upload([self.localDir UTF8String], [self.remoteDir UTF8String]);
                }
            } else {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *cacheDirectory = [paths objectAtIndex:0];
                std::string temporaryFile = rsync::PathUtil::join([cacheDirectory UTF8String], "acrosync.part");
                
                std::set<std::string> filesToInclude;
                if (includeFiles.count > 0) {
                    for (NSString * file in includeFiles) {
                        filesToInclude.insert(std::string([file UTF8String]));
                    }
                    client.download([self.localDir UTF8String], [self.remoteDir UTF8String], temporaryFile.c_str(), &filesToInclude);
                } else {
                    client.download([self.localDir UTF8String], [self.remoteDir UTF8String], temporaryFile.c_str());
                }                
            }
        } catch (rsync::Exception &e) {
            LOG_ERROR(RSYNC_ERROR) << "Sync failed: " << e.getMessage() << LOG_END
        }
        
        libssh2_exit();
    }];

    rsyncOp.completionBlock = ^{
        self.isSyncing = NO;
        NSLog(@"Completed");
    };
    
    [self.operationQueue addOperation:rsyncOp];
}

- (void)connectViaDaemon:(NSString *)server port:(int)port user:(NSString *)user password:(NSString *)password module:(NSString *)module isUploading:(BOOL)isUploading includeFiles:(NSArray*)includeFiles {
    
    NSBlockOperation * rsyncOp = [NSBlockOperation blockOperationWithBlock:^{
        try {
            rsync::SocketIO io;
            
            NSLog(@"Connect %@:%d...", server, port);
            const char *s = [server UTF8String];
            const char *u = [user UTF8String];
            const char *pass = [password UTF8String];
            const char *m = [module UTF8String];
            io.connect(s, port, u, pass, m);
            
            rsync::Client client(&io, "rsync", 30, &self->_g_cancelFlag);
            client.setSpeedLimits(512, 512);
            client.setDeletionEnabled(YES);
            client.setStatsAddresses(&self->_totalBytes, &self->_physicalBytes, &self->_logicalBytes, &self->_skippedBytes);
            
            if (isUploading) {
                client.upload([self.localDir UTF8String], [self.remoteDir UTF8String]);
            } else {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                NSString *cacheDirectory = [paths objectAtIndex:0];
                std::string temporaryFile = rsync::PathUtil::join([cacheDirectory UTF8String], "acrosync.part");
                
                client.download([self.localDir UTF8String], [self.remoteDir UTF8String], temporaryFile.c_str());
            }
            
            [self cleanup];
        } catch (rsync::Exception &e) {
            LOG_ERROR(RSYNC_ERROR) << "Sync failed: " << e.getMessage() << LOG_END
        }
    }];
    
    rsyncOp.completionBlock = ^{
        self.isSyncing = NO;
        NSLog(@"Completed");
    };
    
    [self.operationQueue addOperation:rsyncOp];
    
}

- (void)cancel {
    _g_cancelFlag = 1;
}

- (void)cleanup {
    rsync::SocketUtil::cleanup();
}

@end
