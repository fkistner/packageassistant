/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "DependencyStateTransformer.h"

@implementation DependencyStateTransformer

+ (Class)transformedValueClass
{
    return [NSImage self];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)beforeObject
{
    if (beforeObject == nil) return nil;
    int state = [beforeObject intValue];
    
    switch(state)
    {
        // ok
        case 0:
            return nil;
            break;
            
        // missing
        case 1:
            return [NSImage imageNamed:@"warning"];
            break;
    }
    
    return nil;
}

@end
