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

+ (NSArray*)listPackages
{
    NSArray *receipts = [PKReceipt receiptsOnVolumeAtPath:@"/"];
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:receipts.count];
    
    for(PKReceipt *receipt in receipts)
    {
        // create package
        Package *pkg = [[Package alloc] initWithReceipt:receipt];
        
        // add the package
        [ret addObject:pkg];
    }
    
    return ret;
}

@end
