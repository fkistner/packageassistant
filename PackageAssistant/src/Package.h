/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>

@interface Package : NSObject
{
@private
    // selected for removal?
    NSNumber *_remove;

    // package name without .pkg
    NSString *_name;
    
    // package state
    int _state;
    
    // package dependency list
    NSMutableArray *_dependencies;
}

- (NSString*)name;
- (NSNumber*)remove;
- (int)state;
- (NSArray*)dependencies;
- (void)setDependencies:(id)dependencies;
- (void)clearDependencies;
- (void)setUnknown;
- (void)setOk;
- (void)setBroken;
- (void)setName:(NSString *)name;
- (bool)isOk;

@end
