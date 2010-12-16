/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>
#import "Package.h"

@interface PackageAssistant : NSObject

+ (NSArray*)listPackages;
+ (NSString*)getPackageFile:(NSString*)name;
+ (NSString*)getPackageBaseDir:(NSString*)name;
+ (bool)isApplePackage:(NSString*)name;
+ (NSMutableArray*)getPackageDependencies:(NSString*)pkg;

+ (bool)checkDependencies:(Package*)pkg fast:(bool)fast;
+ (bool)checkDependenciesArray:(NSArray*)deps basedir:(NSString*)dir fast:(bool)fast;

@end
