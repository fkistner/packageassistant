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

@interface MainController : NSObject
{
    IBOutlet NSArrayController *packagesController;
    IBOutlet NSTableView *packagesTable;
    IBOutlet NSTableView *detailsTable;
    IBOutlet NSWindow *mainWindow;
    
    NSNumber *_filter;
    NSMutableArray *_packages;
    Package *_lastSelectedPackage;
}

- (NSMutableArray*)packages;
- (NSNumber*)filter;
- (void)setPackages:(NSMutableArray*)newPackages;
- (void)tableViewSelectionDidChange:(NSNotification *)notification;

- (IBAction)refresh:(id)sender;

@end
