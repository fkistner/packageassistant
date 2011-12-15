/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>
#import "PackageKit/PKReceipt.h"

enum PackageState { StateUnknown, StateOk, StateBroken };

@interface Package : NSObject
{
@private
    // package name without .pkg
    NSString *_name;
    
    // true if it is an apple package
    bool _apple;
    
    // package base directory
    NSString *_basedir;
    
    // files this package depends on
    id <NSFastEnumeration> _rawDeps;
    NSUInteger _count;
    NSArray *_deps;
    
    // package state
    enum PackageState _state;
    
    // selected for removal?
    NSNumber *_remove;
}

@property (readonly,retain,nonatomic) NSString *name;
@property (readonly,assign,nonatomic) bool apple;
@property (readonly,retain,nonatomic) NSString *baseDirectory;
@property (readwrite,retain,nonatomic) NSArray *dependencies;

@property (readwrite,assign,nonatomic) enum PackageState state;
@property (readwrite,retain,nonatomic) NSNumber *remove;

- (Package *)initWithReceipt:(PKReceipt *)receipt andQueue:queue;

@end
