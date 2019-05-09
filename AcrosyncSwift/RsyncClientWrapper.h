//
//  RsyncClientWrapper.h
//  AcrosyncSwift
//
//  Created by Aaron Vegh on 2019-05-04.
//  Copyright © 2019 Aaron Vegh. All rights reserved.
//

#ifndef RsyncClientWrapper_h
#define RsyncClientWrapper_h

typedef NS_ENUM(NSInteger, RsyncLogLevel) {
    LogLevelDebug,
    LogLevelTrace,
    LogLevelInfo,
    LogLevelWarning,
    LogLevelError,
    LogLevelFatal,
    LogLevelAssert
};

@interface RsyncClientWrapper: NSObject

- (instancetype)init:(RsyncLogLevel)logLevel withSSHEnabled:(BOOL)sshEnabled;

@end

#endif /* RsyncClientWrapper_h */
