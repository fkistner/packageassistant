/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "Package.h"

@implementation Package

- (id)init
{
    if(self = [super init])
    {
        _name = [[NSString alloc] initWithString:@"Unknown"];
        _remove = [NSNumber numberWithBool:false];
        _state = 0;
        _dependencies = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [_name release];
    [_dependencies release];

    [super dealloc];
}

- (NSString*)name
{
    return _name;
}

- (NSNumber*)remove
{
    return _remove;
}

- (int)state
{
    return _state;
}

- (NSArray*)dependencies
{
    return _dependencies;
}

- (void)setDependencies:(id)dependencies
{
    // set dependencies pointer
    [_dependencies autorelease];
    _dependencies = [dependencies retain];
    
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

- (bool)isOk
{
    return (_state == 1);
}

- (bool)isBroken
{
    return (_state == 2);
}

- (bool)isUnknown
{
    return (_state == 0);
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

- (void)setName:(NSString *)name
{
    [_name autorelease];
    _name = [name retain];
}

@end
