/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "PackageDependency.h"

@implementation PackageDependency

- (id)initWithFilename:(NSString*)name andState:(bool)broken
{
    if(self = [super init])
    {
        _filename = name;
        _broken = broken;
    }
    return self;
}

@synthesize filename = _filename;
@synthesize broken = _broken;

@end
