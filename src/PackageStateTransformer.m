/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "Package.h"
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
    
    NSNumber *num = beforeObject;
    enum PackageState state = num.intValue;
    switch(state)
    {
        case StateUnknown:
            return [NSImage imageNamed:@"yellow"];
            break;
            
        case StateOk:
            return [NSImage imageNamed:@"green"];
            break;
        
        case StateBroken:
            return [NSImage imageNamed:@"red"];
            break;
    }
    
    return nil;
}

@end
