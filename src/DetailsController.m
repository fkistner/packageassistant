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
    NSMutableArray *matchedObjects =
        [NSMutableArray arrayWithCapacity:[objects count]];

    id item;
	NSEnumerator *oEnum = [objects objectEnumerator];
    while(item = [oEnum nextObject])
	{
        if([item isKindOfClass:[PackageDependency class]] && _filter)
        {
            NSNumber *state = [item valueForKeyPath: @"state"];
            
            if([state boolValue] == true)
            {
                [matchedObjects addObject:item];
            }
        }
        else
        {
           [matchedObjects addObject:item];
        }
    }
    
    return [super arrangeObjects:matchedObjects];
}

- (bool)filter
{
    return _filter;
}

@end
