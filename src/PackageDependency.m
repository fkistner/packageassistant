/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "PackageDependency.h"

@implementation PackageDependency

- (id)init
{
    if(self = [super init])
    {
        _filename = [[NSString alloc] initWithString:@"Unknown"];
        _state = 0;
    }
    
    return self;
}


- (NSString*)filename
{
    return _filename;
}

- (bool)state
{
    return _state;
}

- (bool)isOk
{
    return (_state == 0);
}

- (void)setOk
{
    _state = false;
}

- (void)setBroken
{
    _state = true;
}

- (void)setFilename:(NSString*)name
{
    _filename = [[NSString alloc] initWithString: [name substringFromIndex:1]];
}

@end
