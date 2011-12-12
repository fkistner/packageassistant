/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "Package.h"

@implementation Package

- (Package *)initWithReceipt:(PKReceipt *)receipt andTargetQueue:(dispatch_queue_t)targetQueue
{
    if(self = [super init])
    {
        NSString *ident  = receipt.packageIdentifier;
        NSString *prefix = receipt.installPrefixPath;
        NSArray *groups = receipt.packageGroups;
        
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
//        _receipt = receipt;
        _bom = receipt._BOM;
        
        _queue = dispatch_queue_create("PackageDependency", NULL);
        dispatch_set_target_queue(_queue, targetQueue);
        _deps = nil;
        
        // initalize defaults
        _remove  = [NSNumber numberWithBool:false];
        _state   = StateUnknown;
    }
    
    return self;
}

@synthesize name = _name;
@synthesize apple = _apple;
@synthesize baseDirectory = _basedir;
@synthesize dependencies = _deps;
@synthesize state = _state;
@synthesize remove = _remove;

- (void)determineState
{
    dispatch_async(_queue, ^{
        if (self.state == StateUnknown) {
            NSFileManager *fm = NSFileManager.defaultManager;
            bool fine = YES;
            
            // update package state
            for (NSString *filename in _bom.directoryEnumerator)
            {
                if(filename.length > 0)
                {
                    NSString *fullPath =  [_basedir stringByAppendingPathComponent: filename];
                    
                    // check file existance appending base dir to the dependency
                    if(![fm fileExistsAtPath:fullPath]) {
                        fine = NO;
                        break;
                    }
                }
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.state = (fine ? StateOk : StateBroken);
            });
        }
    });    
}

- (NSArray *)dependencies
{
    if (_deps == nil)
        dispatch_async(_queue, ^{
            if (self.dependencies == nil) {
                __block NSMutableArray *deps = [NSMutableArray arrayWithCapacity:_bom.fileCount];
                __block bool fine = YES;
                
                NSFileManager *fm = NSFileManager.defaultManager;
                
                // update package state
                for (NSString *filename in _bom.directoryEnumerator)
                {
                    if(filename.length > 0)
                    {
                        NSString *fullPath =  [_basedir stringByAppendingPathComponent: filename];
                        
                        PackageDependency *dep = [[PackageDependency alloc] initWithFilename:fullPath];
                        
                        // check file existance appending base dir to the dependency
                        if(![fm fileExistsAtPath:fullPath]) {
                            fine = NO;
                            [dep setBroken:YES];
                        }
                        
                        [deps addObject:dep];
                    }
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.dependencies = deps;
                    self.state = (fine ? StateOk : StateBroken);
                });
            }
        });
    return _deps;
}

- (void)clearDependencies
{
    self.dependencies = nil;
}

@end
