#import <Cocoa/Cocoa.h>

@interface AboutController : NSObject {
    IBOutlet NSWindow *aboutWindow;
}

- (IBAction)aboutClose:(id)sender;
- (IBAction)aboutOpen:(id)sender;

- (NSString*)credits;
- (NSString*)version;

@end
