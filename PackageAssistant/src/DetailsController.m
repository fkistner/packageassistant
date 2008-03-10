#import "DetailsController.h"
#import "PackageDependency.h"
#import <Foundation/NSKeyValueObserving.h>

@implementation DetailsController

- (void)rearrange:(id)sender
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
