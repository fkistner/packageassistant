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
    
    // package base directory
    NSString *_basedir;
    
    // true if it is an apple package
    bool _apple;
}

- (NSString*)name;
- (NSString*)basedir;
- (NSNumber*)remove;
- (int)state;
- (NSArray*)dependencies;
- (bool)isApple;

- (void)setDependencies:(id)dependencies;
- (void)clearDependencies;
- (void)setUnknown;
- (void)setOk;
- (void)setBroken;
- (void)setName:(NSString *)name;
- (void)setBaseDirectory:(NSString *)dir;
- (void)setApple:(bool)ap;
- (bool)isOk;
- (bool)isUnknown;
- (bool)isBroken;

@end
