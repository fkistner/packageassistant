/* SheetController */

#import <Cocoa/Cocoa.h>
#import "PackageLib.h"
#import "MainController.h"

@interface SheetController : NSWindowController
{
    IBOutlet NSPanel *sheet;
    IBOutlet NSTableView *packagesTable;
    IBOutlet NSButton *closeButton;
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSArrayController *packagesController;
    IBOutlet NSTextField *packageLabel;
    IBOutlet NSTextField *titleLabel;
    IBOutlet NSProgressIndicator *progress;
    
    NSLock *lock;
    bool canceled;
}

- (id)init;
- (void)dealloc;

- (IBAction)check:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)remove:(id)sender;

- (void)checkThread:(id)obj;
- (void)removeThread:(id)obj;

@end
