/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "Package.h"

@implementation Package

- (id)initWithName:(NSString *)name baseDirectory:(NSString *)basedir apple:(bool)apple
{
    if(self = [super init])
    {
        _name = name;
        _basedir = basedir;
        _remove = [NSNumber numberWithBool:false];
        _state = StateUnknown;
        _apple = apple;
        _dependencies = [NSMutableArray new];
    }
    
    return self;
}

@synthesize name = _name;
@synthesize baseDirectory = _basedir;
@synthesize remove = _remove;
@synthesize state = _state;
@synthesize dependencies = _dependencies;
@synthesize apple = _apple;

- (void)setDependencies:(id)dependencies
{
    // set dependencies pointer
    _dependencies = dependencies;
    
    // update package state
    self.state = StateOk;
    for (Package *pkg in _dependencies)
    {
        if(pkg.state == StateBroken){
            self.state = StateBroken;
            break;
        }
    }
}

- (void)clearDependencies
{
    [_dependencies removeAllObjects];
}

@end
