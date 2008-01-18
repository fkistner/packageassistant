/* PackageAssistant */

#import <Cocoa/Cocoa.h>

@interface PackageAssistant : NSObject
{
    NSString *receiptsDirectory;
    NSString *bomCommand;
    NSString *bomFile;
}

- (id)init;
- (NSArray*)listPackages;
- (bool)checkDependencies:(NSArray*)deps;
- (bool)fastCheckDependencies:(NSArray*)deps;
- (NSMutableArray*)getPackageDependencies:(NSString*)pkg;

+ (NSString *)getOutput:(NSString *)cmd arguments:(NSArray *)args;

@end
