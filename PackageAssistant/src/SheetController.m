#import "SheetController.h"

@implementation SheetController

- (id)init
{
    if(self = [super init])
    {
        lock = [NSLock new];
    }
    
    return self;
}

- (void)dealloc
{
    [lock release];
    [super dealloc];
}

- (IBAction)check:(id)sender
{   
    [NSApp beginSheet:sheet modalForWindow:mainWindow
        modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    canceled = false;
    
    [NSThread detachNewThreadSelector:@selector(checkThread)
        toTarget:self withObject:nil];
}

- (IBAction)remove:(id)sender
{
    NSBeginAlertSheet(
        @"Do you really want to delete the selected packages?",
                                // sheet message
        @"Delete",              // default button label
        nil,                    // no third button
        @"Cancel",              // other button label
        mainWindow,             // window sheet is attached to
        self,                   // we’ll be our own delegate
        @selector(sheetDidEndShouldDelete:returnCode:contextInfo:),
                                // did-end selector
        NULL,                   // no need for did-dismiss selector
        sender,                 // context info
        @"There is no undo for this operation.",  // additional text
        nil);                   // no parameters in message
}

- (void)sheetDidEndShouldDelete: (NSWindow *)endedSheet
        returnCode: (int)returnCode
        contextInfo: (void *)contextInfo
{
    // end the sheet
    [endedSheet orderOut:nil];
    [NSApp endSheet:endedSheet];

    if (returnCode == NSAlertDefaultReturn);
    {
        [NSApp beginSheet:sheet modalForWindow:mainWindow
            modalDelegate:self didEndSelector:nil contextInfo:nil];
        
        canceled = false;

        [NSThread detachNewThreadSelector:@selector(removeThread)
            toTarget:self withObject:nil];        

    /*
        AuthorizationRef authRef;
        OSStatus status;
        AuthorizationFlags flags;

        flags = kAuthorizationFlagDefaults;
        status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment,  
        flags, &authRef);
               
        if (status != errAuthorizationSuccess) {
           return;
        }

        AuthorizationItem authItems = {kAuthorizationRightExecute, 0, NULL, 0};
        AuthorizationRights rights = {1, &authItems};
        flags = kAuthorizationFlagDefaults |  
        kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize |  
        kAuthorizationFlagExtendRights;
               
        status = AuthorizationCopyRights (authRef, &rights, NULL, flags, NULL);
        if (status != errAuthorizationSuccess) {
           AuthorizationFree(authRef,kAuthorizationFlagDefaults);
           return;
        }

        //FILE* pipe = NULL;
        flags = kAuthorizationFlagDefaults;

//        char* args[1];
//        args[0] = "-rf";

        status =  
        AuthorizationExecuteWithPrivileges(authRef,"RemoveHelper",flags,NULL,NULL);
        AuthorizationExecuteWithPrivileges(authRef,"RemoveHelper",flags,NULL,NULL);

        AuthorizationFree(authRef,kAuthorizationFlagDefaults);
        */
    }
}

// checker thread
- (void)checkThread
{
    [closeButton setTitle:@"Cancel"];
    [packageLabel setStringValue:@"Initializing..."];
    [titleLabel setStringValue:@"Wait while checking the packages..."];
    [progress setDoubleValue:0.0];
    
    int i = 0;
    NSMutableArray *packages = [packagesController arrangedObjects];
    [progress setMaxValue:[packages count]];
    
    bool localcancel = false;
    for(i = 0; i < [packages count] && !localcancel; ++i)
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        Package *pkg = [packages objectAtIndex:i];
        
        // set actual package
        [packageLabel setStringValue:
            [NSString stringWithFormat:@"Checking package: %@...", [pkg name]]];
        
        // check package dependencies
        bool ok = [packageAssistant
            fastCheckDependencies:[packageAssistant
                getPackageDependencies:[pkg name]]];
                
        [pool release];
            
        if(!ok)
            [pkg setBroken];
        else
            [pkg setOk];
            
        // move progress bar
        [progress incrementBy:1.0];
        
        [lock lock];
        localcancel = canceled;
        [lock unlock];
    }

    // show changes in the table
    [packagesTable reloadData];
    
    [closeButton setTitle:@"Close"];
    [packageLabel setStringValue:@"Done!"];
}

// remover thread
- (void)removeThread
{
    [closeButton setTitle:@"Cancel"];
    [packageLabel setStringValue:@"Initializing..."];
    [titleLabel setStringValue:@"Wait while removing the packages..."];
    [progress setDoubleValue:0.0];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remove = 1"];
    NSMutableArray *packages = [packagesController arrangedObjects];
    NSArray *filteredArray = [packages filteredArrayUsingPredicate:predicate];

    [progress setMaxValue:[filteredArray count]];
    
    int i;
    bool localcancel = false;
    for(i = 0; i < [filteredArray count] && !localcancel; ++i)
    {
        Package *pkg = [filteredArray objectAtIndex:i];
        
        // set actual package
        [packageLabel setStringValue:
            [NSString stringWithFormat:@"Removing package: %@...", [pkg name]]];
                    
        // move progress bar
        [progress incrementBy:1.0];
        
        [lock lock];
        localcancel = canceled;
        [lock unlock];
    }
    
    [closeButton setTitle:@"Close"];
    [packageLabel setStringValue:@"Done!"];
}

- (IBAction)cancel:(id)sender
{
    [lock lock];
    canceled = true;
    [lock unlock];

    [sheet orderOut:nil];
    [NSApp endSheet:sheet];
}

@end
