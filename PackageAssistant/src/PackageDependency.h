/* PackageDependency */

#import <Cocoa/Cocoa.h>

@interface PackageDependency : NSObject
{
@private
    // filaname
    NSString *_filename;
    
    // state (DependencyState)
    bool _state;
}

- (NSString*)filename;
- (void)setFilename:(NSString*)name;
- (void)setOk;
- (void)setBroken;
- (bool)isOk;
- (bool)state;

@end
