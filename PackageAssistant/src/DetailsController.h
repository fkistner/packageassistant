#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface DetailsController : NSArrayController
{
    bool _filter;
}

- (void)rearrange:(id)sender;
- (bool)filter;

@end
