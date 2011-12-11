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

@property (readwrite,retain,nonatomic) NSString *name;
@property (readwrite,retain,nonatomic) NSString *baseDirectory;
@property (readwrite,retain,nonatomic) NSNumber *remove;
@property (readwrite,retain,nonatomic) NSArray *dependencies;
@property (readwrite,assign,nonatomic) bool apple;

- (id)initWithName:(NSString *)name baseDirectory:(NSString *)basedir apple:(bool)apple;
- (void)clearDependencies;
- (void)setUnknown;
- (void)setOk;
- (void)setBroken;
- (bool)isUnknown;
- (bool)isOk;
- (bool)isBroken;

@end
