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

- (id)init
{
    if (self = [super init])
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (NSArray*)listPackages
{
    __weak NSOperationQueue *queue = _queue;
    NSArray *receipts = [PKReceipt receiptsOnVolumeAtPath:@"/"];
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:receipts.count];
    
    for(PKReceipt *receipt in receipts)
    {
        [queue addOperationWithBlock:^{
            // create package
            Package *pkg = [[Package alloc] initWithReceipt:receipt andQueue:queue];
            
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [ret addObject:pkg];
            }];
        }];
    }
    
    return ret;
}

- (void)cancel
{
    [_queue cancelAllOperations];
}

@end
