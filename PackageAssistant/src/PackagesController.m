#import "PackagesController.h"

@implementation PackagesController

- (void)dealloc
{
    [super dealloc];
}

- (NSString*)searchString
{
    return _searchString;
}

- (void)setSearchString:(NSString*)str
{
    if (_searchString != str)
	{
        [_searchString autorelease];
        _searchString = [str copy];
    }
}

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
        [NSMutableArray arrayWithCapacity:[objects count]];

    // case-insensitive search
    NSString *lowerSearch = [_searchString lowercaseString];

    id item;    
	NSEnumerator *oEnum = [objects objectEnumerator];
    while (item = [oEnum nextObject])
	{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *lowerName = [[item valueForKeyPath:@"name"] lowercaseString];
        
        if ([lowerName rangeOfString:lowerSearch].location != NSNotFound)
        {
            [matchedObjects addObject:item];
        }
        
        [pool release];
    }
    
    return [super arrangeObjects:matchedObjects];
}

@end
