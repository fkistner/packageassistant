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
