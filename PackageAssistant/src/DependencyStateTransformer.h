#import <Cocoa/Cocoa.h>

@interface DependencyStateTransformer : NSObject {
}

+ (Class)transformedValueClass;
+ (BOOL)allowsReverseTransformation;

- (id)transformedValue:(id)beforeObject;

@end
