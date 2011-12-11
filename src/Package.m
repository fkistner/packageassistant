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
        _state = 0;
        _apple = false;
        _dependencies = [NSMutableArray new];
    }
    
    return self;
}

@synthesize name = _name;
@synthesize baseDirectory = _basedir;
@synthesize remove = _remove;
// handle state differently
@synthesize dependencies = _dependencies;
@synthesize apple = _apple;

- (void)setDependencies:(id)dependencies
{
    // set dependencies pointer
    _dependencies = dependencies;
    
    // update package state
    int i = 0;
    int total = [_dependencies count];
    [self setOk];
    while(i < total && [self isOk])
    {
        if(![[_dependencies objectAtIndex:i] isOk])
            [self setBroken];
        i++;
    }
}

- (void)clearDependencies
{
    [_dependencies removeAllObjects];
}

- (bool)isUnknown
{
    return (_state == 0);
}

- (bool)isOk
{
    return (_state == 1);
}

- (bool)isBroken
{
    return (_state == 2);
}

- (void)setUnknown
{
    _state = 0;
}

- (void)setOk
{
    _state = 1;
}

- (void)setBroken
{
    _state = 2;
}

@end
