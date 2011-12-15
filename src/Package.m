/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "Package.h"
#import "PackageDependency.h"
#import "PackageDetermineDependencies.h"
#import "BOM.h"

@implementation Package

- (Package *)initWithReceipt:(PKReceipt *)receipt andQueue:queue
{
    if(self = [super init])
    {
        NSString *ident  = receipt.packageIdentifier;
        NSArray *groups = receipt.packageGroups;
        NSString *prefix = receipt.installPrefixPath;
        
        // predetermine package infos
        if (groups == nil)
        {
            _name = ident;
        } else {
            _name = [ident stringByAppendingFormat:@" [%@]", [groups componentsJoinedByString: @", "]];   
        }
        _apple = [ident hasPrefix:@"com.apple."];
        
        if ([prefix hasPrefix:@"/"])
        {
            _basedir = prefix;
        } else {
            _basedir = [@"/" stringByAppendingString:prefix];
        }
        
        // save receipt for later use
        id <BOM> bom = receipt._BOM;
        _rawDeps = bom.directoryEnumerator;
        _count = bom.fileCount;
        _deps = nil;
        
        // initalize defaults
        _remove  = [NSNumber numberWithBool:false];
        _state   = StateUnknown;
        
        // schedule dependency determination
        NSOperation *detDeps = [[PackageDetermineDependencies alloc] initWithBaseDirectory:_basedir andRawDependencies:_rawDeps count:_count andResultBlock:^(NSArray *deps, bool broken) {
            self.dependencies = deps;
            self.state = (broken ? StateBroken : StateOk);
        }];
        [detDeps setThreadPriority:0.1];
        [detDeps setQueuePriority:NSOperationQueuePriorityVeryLow];
        [queue addOperation:detDeps];
    }
    
    return self;
}

@synthesize name = _name;
@synthesize apple = _apple;
@synthesize baseDirectory = _basedir;
@synthesize dependencies = _deps;
@synthesize state = _state;
@synthesize remove = _remove;

@end
