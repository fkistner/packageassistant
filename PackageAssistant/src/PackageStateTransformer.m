/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "PackageStateTransformer.h"

@implementation PackageStateTransformer

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
        case 0:
            return [NSImage imageNamed:@"yellow"];
            break;
            
        case 1:
            return [NSImage imageNamed:@"green"];
            break;
        
        case 2:
            return [NSImage imageNamed:@"red"];
            break;
    }
    
    return nil;
}

@end
