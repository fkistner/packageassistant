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

@interface MainController : NSObject
{
    IBOutlet PackagesController *packagesController;
    IBOutlet NSTableView *packagesTable;
    IBOutlet NSTableView *detailsTable;
    IBOutlet NSWindow *mainWindow;
    IBOutlet NSPanel *aboutBox;
            
    NSMutableArray *_packages;
    Package *_lastSelectedPackage;
}

- (NSMutableArray*)packages;
- (void)setPackages:(NSMutableArray*)newPackages;
- (void)tableViewSelectionDidChange:(NSNotification *)notification;

- (NSString*)license;
- (NSString*)contributors;

- (IBAction)refresh:(id)sender;
- (IBAction)doSearch:(id)sender;
- (IBAction)aboutOpen:(id)sender;
- (IBAction)aboutClose:(id)sender;

@end
