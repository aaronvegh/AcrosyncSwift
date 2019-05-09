//
//  AdditionalWrappers.m
//  AcrosyncSwift
//
//  Created by Aaron Vegh on 2019-05-04.
//  Copyright © 2019 Aaron Vegh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternalHeaders.h"
#import "RsyncClientWrapper.h"

@implementation RsyncClientWrapper

- (instancetype)init:(RsyncLogLevel)logLevel withSSHEnabled:(BOOL)sshEnabled {
    self = [super init];
    if (sshEnabled) {
        rsync::SSHIO sshio;
        
    }
    
    return self;
}

@end
