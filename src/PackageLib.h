/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>
#import "Package.h"

@interface PackageAssistant : NSObject
{
    @private   
    dispatch_queue_t _queue;
}

+ (id)sharedInstance;
- (NSArray*)listPackages;

@end
