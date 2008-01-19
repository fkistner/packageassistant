/* PackageAssistant */

#import <Cocoa/Cocoa.h>

@interface PackageAssistant : NSObject

+ (NSArray*)listPackages;
+ (NSString*)getPackageFile:(NSString*)name;
+ (NSMutableArray*)getPackageDependencies:(NSString*)pkg;

+ (bool)checkDependencies:(NSArray*)deps fast:(bool)fast;

@end
