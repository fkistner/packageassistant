/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "PackageLib.h"
#import "PackageDependency.h"

#import <stdio.h>
#import <string.h>
#import <Cocoa/Cocoa.h>

int longestFirst(PackageDependency *a, PackageDependency *b, void *ctx)
{
    if([[a filename] length] == [[b filename] length])
    {
        return 0;
    }
    else if([[a filename] length] > [[b filename] length])
    {
        return -1;
    }
    else
    {
        return 1;
    }
}

int main(int argc, char *argv[])
{
    long len;
    char *buf;
    char cmd[1024] = {0};

    // protocol is:
    // expect package name length (long)
    // read name
    // delete
    // write result (zero or one, long)
    while(read(fileno(stdin), &len, sizeof(len)))
    {
        @autoreleasepool {
            
            buf = malloc(len);
            read(fileno(stdin), buf, len);
            NSString *objcname = [NSString stringWithCString:buf
                encoding:NSUTF8StringEncoding];
#ifdef __HELPER_DEBUG__
            NSLog(@"About to delete: %@", objcname);
#endif
            // remove dependencies
            NSString *basedir = [PackageAssistant getPackageBaseDir:objcname];
            NSArray *pdeps = [PackageAssistant getPackageDependencies:objcname];
            NSMutableArray *deps = [NSMutableArray arrayWithArray:pdeps];
            [deps sortUsingFunction:&longestFirst context:nil];
            
            int i;
            for(i = 0; i < [deps count]; i++)
            {
                sprintf(cmd, "/bin/rm -f \"%s%s\"",
                    [basedir cStringUsingEncoding:NSUTF8StringEncoding],
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
        
        }
    }
    
    return 0;
}
