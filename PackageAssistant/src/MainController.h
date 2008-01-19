/* MainController */

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
