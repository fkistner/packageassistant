/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "PackagesController.h"

@implementation PackagesController


@synthesize searchString = _searchString;

- (IBAction)search:(id)sender
{
    [self rearrangeObjects];
}

- (NSArray *)arrangeObjects:(NSArray *)objects
{	
    if ((_searchString == nil) ||
		([_searchString isEqualToString:@""]))
	{
		return [super arrangeObjects:objects];   
	}
	
    NSMutableArray *matchedObjects =
        [NSMutableArray arrayWithCapacity:objects.count];

    // case-insensitive search
    NSString *lowerSearch = _searchString.lowercaseString;
    
    for(Package *item in objects)
	{
        @autoreleasepool {
            if ([item.name.lowercaseString rangeOfString:lowerSearch].location != NSNotFound)
            {
                [matchedObjects addObject:item];
            }
            
        }
    }
    
    return [super arrangeObjects:matchedObjects];
}

@end
