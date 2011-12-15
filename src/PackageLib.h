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
    NSOperationQueue *_queue;
}

+ (id)sharedInstance;
- (NSArray*)listPackages;
- (void)cancel;

@end
