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

- (void)dealloc
{
    [_filename release];

    [super dealloc];
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
    [_filename autorelease];
    _filename = [[NSString alloc] initWithString: [name substringFromIndex:1]];
}

@end
