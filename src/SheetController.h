/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>
#import "PackageLib.h"
#import "MainController.h"

@interface SheetController : NSWindowController
{
    IBOutlet NSPanel *sheet;
    IBOutlet NSTableView *detailsTable;
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

- (IBAction)check:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)remove:(id)sender;

- (void)checkThread:(id)obj;
- (void)removeThread:(id)obj;

@end
