#import <Cocoa/Cocoa.h>

@interface PackageStateTransformer : NSObject {
}

+ (Class)transformedValueClass;
+ (BOOL)allowsReverseTransformation;

- (id)transformedValue:(id)beforeObject;

@end
