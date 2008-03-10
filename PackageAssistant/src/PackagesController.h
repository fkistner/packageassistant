#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface PackagesController : NSArrayController {
    NSString *_searchString;
}

- (NSString*)searchString;
- (IBAction)search:(id)sender;

@end
