#import <Cocoa/Cocoa.h>

@interface AboutController : NSObject {
    IBOutlet NSWindow *aboutWindow;
}

- (IBAction)aboutClose:(id)sender;
- (IBAction)aboutOpen:(id)sender;

@property (readonly,nonatomic) NSString* credits;
@property (readonly,nonatomic) NSString* version;

@end
