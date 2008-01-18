#import <Security/Authorization.h>
#include <Security/AuthorizationTags.h>

#import "Package.h"
#import "MainController.h"
#import "PackageStateTransformer.h"
#import "DependencyStateTransformer.h"

@implementation MainController

- (void)awakeFromNib
{
    // register image transformers
    id pst = [[[PackageStateTransformer alloc] init] autorelease];
    id dst = [[[DependencyStateTransformer alloc] init] autorelease];
    
    [NSValueTransformer
        setValueTransformer:pst
        forName:@"PackageStateTransformer"];

    [NSValueTransformer
        setValueTransformer:dst
        forName:@"DependencyStateTransformer"];

    // refresh
    [self refresh:nil];
}

- (id)init
{
    if(self = [super init])
    {
        _filter = [NSNumber new];
        _packages = [NSMutableArray new];
        _lastSelectedPackage = nil;
    }

    return self;
}

- (void)dealloc
{
    [_packages release];
    
    [super dealloc];
}

- (NSMutableArray*) packages
{
    return _packages;
}

- (NSNumber*)filter
{
    return _filter;
}

- (void)setPackages:(NSMutableArray*)newPackages
{
    if(_packages != newPackages)
    {
        [_packages autorelease];
        _packages = [[NSMutableArray alloc] initWithArray: newPackages];
    }
}

- (IBAction)addPackage:(id)sender
{
}

- (IBAction)removePackage:(id)sender
{
}

- (IBAction)refresh:(id)sender
{
    [packagesController setContent:[packageAssistant listPackages]];
}

// tableView
// got to load selected item dependencies and free the last one
- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    // free last selected package dependencies
    if(_lastSelectedPackage != nil)
       [_lastSelectedPackage clearDependencies]; 

    int row = [packagesTable selectedRow];
    
    if(row != -1)
    {
        // set the new package
        _lastSelectedPackage =
            [[packagesController selectedObjects] objectAtIndex:0];
            
        // get the package's dependencies
        NSArray *deps = [packageAssistant getPackageDependencies:
                [_lastSelectedPackage name]];

        // check them
        [packageAssistant checkDependencies:deps];
    
        // load package's dependencies
        [_lastSelectedPackage setDependencies:deps];
    }
    
    [packagesTable reloadData];
}

- (NSPredicate*)tableFilter
{
    return [NSPredicate predicateWithFormat:@"state = %d", _filter];
}

@end
