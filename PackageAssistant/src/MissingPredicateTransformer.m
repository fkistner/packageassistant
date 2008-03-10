#import "MissingPredicateTransformer.h"

@implementation MissingPredicateTransformer

+ (Class)transformedValueClass
{
    return [NSPredicate self];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
    NSNumber *num = value;
    return [NSPredicate predicateWithFormat:@"1 = %d", num];
}

@end
