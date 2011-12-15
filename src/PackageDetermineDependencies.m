//
//  PackageDetermineDependencies.m
//  PackageAssistant
//
//  Created by Florian Kistner on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PackageDetermineDependencies.h"
#import "PackageDependency.h"

@implementation PackageDetermineDependencies

- (id)initWithBaseDirectory:(NSString*)basedir andRawDependencies:(id <NSFastEnumeration>)rawDep count:(NSUInteger)count andResultBlock:(PackageDetermineDependenciesResult)resultBlock
{
    if (self = [super init])
    {
        _basedir = basedir;
        _rawDep = rawDep;
        _count = count;
        _result = resultBlock;
    }
    return self;
}

- (void)main
{
    if (!self.isCancelled) {
        NSFileManager *fm = NSFileManager.defaultManager;
        NSMutableArray *_deps = [NSMutableArray arrayWithCapacity:_count];
        
        bool pkgBroken = NO;
        
        // update package state
        for (NSString *filename in _rawDep)
        {
            if(filename.length > 0)
            {
                NSString *fullPath = [_basedir stringByAppendingPathComponent: filename];
                
                // check file existance appending base dir to the dependency
                bool depBroken = ![fm fileExistsAtPath:fullPath];
                pkgBroken |= depBroken;
                
                PackageDependency *dep = [[PackageDependency alloc] initWithFilename:fullPath andState:depBroken];
                [_deps addObject:dep];
            }
        }

        _result(_deps, pkgBroken);
    }
}

@end
