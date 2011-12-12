/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>
#import "Package.h"
#import "PackageLib.h"
#import "PackagesController.h"
#import "AboutController.h"

@interface MainController : NSObject
{
    IBOutlet PackagesController *packagesController;
    IBOutlet AboutController *aboutController;
    IBOutlet NSTableView *packagesTable;
    IBOutlet NSTableView *detailsTable;
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSProgressIndicator *loading;
    IBOutlet NSTextField *version;
            
    NSMutableArray *_packages;
    Package *_lastSelectedPackage;
}

- (IBAction)refresh:(id)sender;
- (IBAction)doSearch:(id)sender;

@property (readwrite,copy,nonatomic) NSMutableArray* packages;

- (void)tableViewSelectionDidChange:(NSNotification *)notification;

@end
