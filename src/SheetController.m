/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Security/Authorization.h>
#import <Security/AuthorizationTags.h>

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

- (IBAction)check:(id)sender
{   
    [NSApp beginSheet:sheet modalForWindow:mainWindow
        modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    canceled = false;
    
    [NSThread detachNewThreadSelector:@selector(checkThread:)
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
        nil,                    // context info
        @"There is no undo for this operation.",  // additional text
        nil);                   // no parameters in message
}

- (void)sheetDidEndShouldDelete:(NSWindow *)endedSheet
        returnCode: (int)returnCode
        contextInfo: (void *)contextInfo
{
    // end the sheet
    [endedSheet orderOut:nil];
    [NSApp endSheet:endedSheet];

    if (returnCode == NSAlertDefaultReturn)
    {
        OSStatus status;
        AuthorizationFlags flags;
        AuthorizationRef authRef;

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

        [NSApp beginSheet:sheet modalForWindow:mainWindow
            modalDelegate:self didEndSelector:nil contextInfo:nil];
        
        canceled = false;

        [NSThread detachNewThreadSelector:@selector(removeThread:)
            toTarget:self withObject:[NSNumber numberWithLong:(long)authRef]];
    }
}

// checker thread
- (void)checkThread:(id)obj
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
        @autoreleasepool {
        
        Package *pkg = [packages objectAtIndex:i];
        
        // set actual package
        [packageLabel setStringValue:
            [NSString stringWithFormat:@"Checking package: %@...", [pkg name]]];
        
        // force redraw
        [packageLabel display];
        
        if([pkg isUnknown])
        {
            // check package dependencies
            NSArray *deps = [PackageAssistant
                getPackageDependencies:[pkg name]];
                
            bool error = [PackageAssistant checkDependenciesArray:deps
                basedir:[pkg baseDirectory] fast:true];
                
            if(error)
                [pkg setBroken];
            else
                [pkg setOk];
        }

        }
        
        // move progress bar
        [progress incrementBy:1.0];
        
        [lock lock];
        localcancel = canceled;
        [lock unlock];
    }

    // show changes in the table
    [detailsTable reloadData];
    
    [closeButton setTitle:@"Close"];
    [packageLabel setStringValue:@"Done!"];
}

// remover thread
- (void)removeThread:(id)obj
{
    AuthorizationRef authRef = (AuthorizationRef) [(NSNumber*)obj longValue];

    [closeButton setTitle:@"Cancel"];
    [packageLabel setStringValue:@"Initializing..."];
    [titleLabel setStringValue:@"Wait while removing the packages..."];
    [progress setDoubleValue:0.0];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remove = 1"];
    NSMutableArray *packages = [packagesController arrangedObjects];
    NSArray *filteredArray = [packages filteredArrayUsingPredicate:predicate];

    [progress setMaxValue:[filteredArray count]];

    FILE* pipe = NULL;

    // get path
    const char *helperPath = [[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"RemoveHelper"] UTF8String];

    // call helper with root priviledges
    AuthorizationExecuteWithPrivileges(authRef, helperPath, kAuthorizationFlagDefaults, NULL, &pipe);

    int i;
    bool localcancel = false;
    for(i = 0; i < [filteredArray count] && !localcancel; ++i)
    {
        @autoreleasepool {
        Package *pkg = [filteredArray objectAtIndex:i];
        
        // set actual package
        [packageLabel setStringValue:
            [NSString stringWithFormat:@"Removing package: %@...", [pkg name]]];
            
        // force redraw
        [packageLabel display];
            
        const char *n = [[pkg name] cStringUsingEncoding:NSUTF8StringEncoding];
        long len = strlen(n);
        write(fileno(pipe), &len, sizeof(len));
        write(fileno(pipe), n, len);
        read(fileno(pipe), &len, sizeof(len));
                            
        }
        
        // move progress bar
        [progress incrementBy:1.0];
        
        [lock lock];
        localcancel = canceled;
        [lock unlock];
    }

    // close pipe
    fclose(pipe);

    // free authorization
    AuthorizationFree(authRef, kAuthorizationFlagDefaults);
    
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
