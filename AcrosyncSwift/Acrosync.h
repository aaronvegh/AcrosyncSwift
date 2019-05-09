//
//  Acrosync.h
//  AcrosyncSwift
//
//  Created by Aaron Vegh on 2019-05-04.
//  Copyright © 2019 Aaron Vegh. All rights reserved.
//

#ifndef Acrosync_h
#define Acrosync_h

#import "RsyncClientWrapper.h"

@interface Acrosync: NSObject

@property (nonatomic, assign, readwrite) BOOL sshEnabled;
@property (nonatomic, strong, readwrite) NSString * remoteDir;
@property (nonatomic, strong, readwrite) NSString * localDir;
@property (nonatomic, strong, readwrite) NSString * module;
@property (nonatomic, strong, readwrite) RsyncClientWrapper * rsyncClient;
@property (nonatomic, strong, readwrite) NSProgress * progress;
@property (readwrite, assign) BOOL isSyncing;
@property (readwrite, assign) int64_t totalBytes;
@property (readwrite, assign) int64_t physicalBytes;
@property (readwrite, assign) int64_t logicalBytes;
@property (readwrite, assign) int64_t skippedBytes;
@property (readwrite, assign) int uploadKbps;
@property (readwrite, assign) int downloadKbps;
@property (readwrite, assign) BOOL deletionEnabled;

- (void)startRsync:(RsyncLogLevel)atLogLevel;
- (void)connectViaSSH:(NSString *)server port:(int)port user:(NSString *)user password:(NSString*)password keyPath:(NSString*)keyPath isUploading:(BOOL)isUploading  includeFiles:(NSArray*)includeFiles;
- (void)connectViaDaemon:(NSString *)server port:(int)port user:(NSString *)user password:(NSString*)password module:(NSString *)module isUploading:(BOOL)isUploading includeFiles:(NSArray*)includeFiles;
- (void)cancel;
- (void)cleanup;

@end

#endif /* Acrosync_h */
