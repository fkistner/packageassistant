/*
 Copyright (c) 2008, PackageAssistant contributors.
 All rights reserved. See CONTRIBUTORS file for the list of authors.
 This piece of software is distributed under the NEW BSD License.
 You should have a LICENSE file along with this distribution
 look at it for more information.
 */

#import "Package.h"
#import "PackageLib.h"
#import "PackageDependency.h"
#import "PackageKit/PKReceipt.h"

@implementation PackageAssistant

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static PackageAssistant *p = nil;
    dispatch_once(&pred, ^{
        p = [[self alloc] init];
    });
    return p;
}

-(id)init
{
    _queue = dispatch_queue_create("Packages", DISPATCH_QUEUE_CONCURRENT);
}

- (NSArray*)listPackages
{
    NSArray *receipts = [PKReceipt receiptsOnVolumeAtPath:@"/"];
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:receipts.count];
    
    for(PKReceipt *receipt in receipts)
    {
        // create package
        Package *pkg = [[Package alloc] initWithReceipt:receipt andTargetQueue:_queue];
        
        [pkg determineState];
        
        // add the package
        [ret addObject:pkg];
    }
    
    return ret;
}

-(void)cancel
{
    
}

@end
