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

- (IBAction)check:(id)sender
{   
    [NSApp beginSheet:sheet modalForWindow:mainWindow
        modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    closeButton.title = @"Cancel";
    packageLabel.stringValue = @"Initializing...";
    titleLabel.stringValue = @"Wait while checking the packages...";
    progress.doubleValue = 0.0;
    
    NSMutableArray *packages = packagesController.arrangedObjects;
    progress.maxValue = packages.count;
    
    for(Package *pkg in packages)
    {
        // set actual package
        packageLabel.stringValue = [NSString stringWithFormat:@"Checking package: %@...", pkg.name];
        
        // force redraw
        [packageLabel display];
        
        [pkg determineState];
        
        // move progress bar
        [progress incrementBy:1.0];
    }
    
    packageLabel.stringValue = @"Done!";
    
    [sheet orderOut:nil];
    [NSApp endSheet:sheet];
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
        AuthorizationFlags flags;
        AuthorizationRef authRef;

        flags = kAuthorizationFlagDefaults;
        if (AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, flags, &authRef) != errAuthorizationSuccess)
           return;

        AuthorizationItem authItems = {kAuthorizationRightExecute, 0, NULL, 0};
        AuthorizationRights rights = {1, &authItems};
        flags = kAuthorizationFlagDefaults |  
        kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize |  
        kAuthorizationFlagExtendRights;
               
        if (AuthorizationCopyRights(authRef, &rights, NULL, flags, NULL) != errAuthorizationSuccess)
        {
           AuthorizationFree(authRef,kAuthorizationFlagDefaults);
           return;
        }

        [NSApp beginSheet:sheet modalForWindow:mainWindow
            modalDelegate:self didEndSelector:nil contextInfo:nil];
        
//        canceled = false;
//
//        [NSThread detachNewThreadSelector:@selector(removeThread:)
//                                 toTarget:self withObject:^AuthorizationRef{
//                                     return authRef;
//                                 }];
    }
}

// remover thread
//- (void)removeThread:(id)obj
//{
//    AuthorizationRef (^getAuthRef)() = obj;
//    AuthorizationRef authRef = getAuthRef();
//
//    closeButton.title = @"Cancel";
//    packageLabel.stringValue = @"Initializing...";
//    titleLabel.stringValue = @"Wait while removing the packages...";
//    progress.doubleValue = 0.0;
//
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"remove = 1"];
//    NSMutableArray *packages = packagesController.arrangedObjects;
//    NSArray *filteredArray = [packages filteredArrayUsingPredicate:predicate];
//
//    [progress setMaxValue:filteredArray.count];
//
//    FILE* pipe = NULL;
//
//    // get path
//    const char *helperPath = [NSBundle.mainBundle pathForAuxiliaryExecutable:@"RemoveHelper"].UTF8String;
//
//    // call helper with root priviledges
////    AuthorizationExecuteWithPrivileges(authRef, helperPath, kAuthorizationFlagDefaults, NULL, &pipe);
//
//    for(Package *pkg in filteredArray)
//    {
//        @autoreleasepool {            
//            // set actual package
//            packageLabel.stringValue = [NSString stringWithFormat:@"Removing package: %@...", pkg.name];
//            
//            // force redraw
//            [packageLabel display];
//            
//            const char *n = pkg.name.UTF8String;
//            long len = strlen(n);
//            write(fileno(pipe), &len, sizeof(len));
//            write(fileno(pipe), n, len);
//            read(fileno(pipe), &len, sizeof(len));   
//        }
//        
//        // move progress bar
//        [progress incrementBy:1.0];
//        
//        [lock lock];
//        if (canceled)
//            break;
//        [lock unlock];
//    }
//
//    // close pipe
//    fclose(pipe);
//
//    // free authorization
//    AuthorizationFree(authRef, kAuthorizationFlagDefaults);
//    
//    closeButton.title = @"Close";
//    packageLabel.stringValue = @"Done!";
//}

- (IBAction)cancel:(id)sender
{
    [sheet orderOut:nil];
    [NSApp endSheet:sheet];
}

@end
