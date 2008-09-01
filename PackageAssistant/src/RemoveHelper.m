/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "PackageLib.h"

#import <stdio.h>
#import <string.h>
#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    long len;
    char *buf;
    char cmd[1024] = {0};

    // protocol is:
    // expect name length (long)
    // read name
    // delete
    // write result (zero or one, long)
    while(read(fileno(stdin), &len, sizeof(len)))
    {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            
        buf = malloc(len);
        read(fileno(stdin), buf, len);
        NSString *objcname = [NSString stringWithCString:buf
            encoding:NSUTF8StringEncoding];
#ifdef __HELPER_DEBUG__
        NSLog(@"About to delete: %@", objcname);
#endif
        // remove dependencies
        NSArray *deps = [PackageAssistant getPackageDependencies:objcname];
        
        int i;
        for(i = 0; i < [deps count]; i++)
        {
            sprintf(cmd, "/bin/rm -f \"%s\"", 
                [[[deps objectAtIndex:i] filename]
                    cStringUsingEncoding:NSUTF8StringEncoding]);
#ifdef __HELPER_DEBUG__
            NSLog(@"About to execute: %s", cmd);
#endif
            system(cmd);
        }
        
        // remove receipt
        sprintf(cmd, "/bin/rm -rf \"%s\"",
            [[PackageAssistant getPackageFile: objcname]
                    cStringUsingEncoding:NSUTF8StringEncoding]);
#ifdef __HELPER_DEBUG__                
        NSLog(@"About to execute: %s", cmd);
#endif
        system(cmd);
        
        free(buf);
        
        // return ok
        len = 1;
        write(fileno(stdout), &len, sizeof(len));
        
        [pool release];
    }
    
    return 0;
}
