//
//  Acrosync.h
//  AcrosyncSwift
//
//  Created by Aaron Vegh on 2019-05-04.
//  This is free and unencumbered software released into the public domain.

// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.
//
// In jurisdictions that recognize copyright laws, the author or authors
// of this software dedicate any and all copyright interest in the
// software to the public domain. We make this dedication for the benefit
// of the public at large and to the detriment of our heirs and
// successors. We intend this dedication to be an overt act of
// relinquishment in perpetuity of all present and future rights to this
// software under copyright law.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//
// For more information, please refer to [http://unlicense.org]
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
