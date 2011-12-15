//
//  PackageDetermineDependencies.h
//  PackageAssistant
//
//  Created by Florian Kistner on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Package.h"

typedef void(^PackageDetermineDependenciesResult)(NSArray *deps, bool broken);

@interface PackageDetermineDependencies : NSOperation
{
    @private
    NSString *_basedir;
    id <NSFastEnumeration> _rawDep;
    NSUInteger _count;
    PackageDetermineDependenciesResult _result;
}

- (id)initWithBaseDirectory:(NSString*)basedir andRawDependencies:(id <NSFastEnumeration>)rawDep count:(NSUInteger)count andResultBlock:(PackageDetermineDependenciesResult)resultBlock;

@end
