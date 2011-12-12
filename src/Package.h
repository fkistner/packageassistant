/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>

enum PackageState { StateUnknown, StateOk, StateBroken };

@interface Package : NSObject
{
@private
    // selected for removal?
    NSNumber *_remove;

    // package name without .pkg
    NSString *_name;
    
    // package state
    enum PackageState _state;
    
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
@property (readwrite,assign,nonatomic) enum PackageState state;
@property (readwrite,retain,nonatomic) NSArray *dependencies;
@property (readwrite,assign,nonatomic) bool apple;

- (id)initWithName:(NSString *)name baseDirectory:(NSString *)basedir apple:(bool)apple;
- (void)clearDependencies;

@end
