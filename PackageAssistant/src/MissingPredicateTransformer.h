#import <Cocoa/Cocoa.h>

@interface MissingPredicateTransformer : NSObject {
}

+ (Class)transformedValueClass;
+ (BOOL)allowsReverseTransformation;

- (id)transformedValue:(id)beforeObject;

@end
