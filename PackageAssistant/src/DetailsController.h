#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface DetailsController : NSArrayController
{
    bool _filter;
}

- (IBAction)rearrange:(id)sender;
- (bool)filter;

@end
