/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "DetailsController.h"
#import "PackageDependency.h"
#import <Foundation/NSKeyValueObserving.h>

@implementation DetailsController

- (IBAction)rearrange:(id)sender
{
    [self rearrangeObjects];    
}

- (NSArray *)arrangeObjects:(NSArray *)objects
{	
    if (_filter) {
        NSMutableArray *matchedObjects = [NSMutableArray arrayWithCapacity:objects.count];
        for(PackageDependency *dep in objects)
        {
            if(dep.broken)
                [matchedObjects addObject:dep];
        }
        return [super arrangeObjects:matchedObjects];
    } else {
        return [super arrangeObjects:objects];        
    }
}

@synthesize filter = _filter;

@end
