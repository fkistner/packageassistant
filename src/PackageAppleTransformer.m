/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "PackageAppleTransformer.h"

@implementation PackageAppleTransformer

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
    if(beforeObject == nil) return nil;
    
    NSNumber *num = beforeObject;
    if(num.boolValue)
    {
        return [NSImage imageNamed:@"apple"];
    }
    
    return nil;
}

@end
