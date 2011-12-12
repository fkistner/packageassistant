/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "Package.h"
#import "MainController.h"
#import "PackageStateTransformer.h"
#import "DependencyStateTransformer.h"
#import "PackageAppleTransformer.h"
#import "BuildInformation.h"

@implementation MainController

- (void)awakeFromNib
{
    // register image transformers
    id pst = [PackageStateTransformer new];
    id dst = [DependencyStateTransformer new];
    id pat = [PackageAppleTransformer new];
        
    [NSValueTransformer
        setValueTransformer:pst
        forName:@"PackageStateTransformer"];

    [NSValueTransformer
        setValueTransformer:dst
        forName:@"DependencyStateTransformer"];

    [NSValueTransformer
        setValueTransformer:pat
        forName:@"PackageAppleTransformer"];

    // center window
    [mainWindow center];
    
    // refresh
    [self refresh:nil];
}

- (id)init
{
    if(self = [super init])
    {
        _packages = [NSMutableArray new];
        _lastSelectedPackage = nil;
    }

    return self;
}

@synthesize packages = _packages;

- (IBAction)refresh:(id)sender
{
    packagesController.content = [PackageAssistant listPackages];
}

- (IBAction)doSearch:(id)sender
{
    // search
    [packagesController search:sender];
    
    // update details
    [self tableViewSelectionDidChange:nil];
    
    // select search field
    NSTextField *textField = sender;
    [textField selectText:self];
}

// tableView
// got to load selected item dependencies and free the last one
- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    // free last selected package dependencies
    if(_lastSelectedPackage != nil)
       [_lastSelectedPackage clearDependencies]; 
    
    if(packagesTable.selectedRow != -1)
    {
        // set the new package
        _lastSelectedPackage = [packagesController.selectedObjects objectAtIndex:0];
        
        // progress indicator GO
        [loadingIndicator startAnimation:self];
        
        // get the package's dependencies
        NSArray *deps = [PackageAssistant getPackageDependencies:_lastSelectedPackage.name];

        // load package's dependencies
        [_lastSelectedPackage setDependencies:deps];

        // check them
        [PackageAssistant checkDependencies:_lastSelectedPackage fast:false];   

        // progress indicator STOP
        [loadingIndicator stopAnimation:self];
    }
    
    [packagesTable reloadData];
}

@end
