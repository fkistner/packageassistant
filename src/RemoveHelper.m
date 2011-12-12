/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <stdio.h>
#import <string.h>
#import <Cocoa/Cocoa.h>

#import "PackageLib.h"
#import "PackageDependency.h"

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
            NSString *objcname = [NSString stringWithUTF8String:buf];
#ifdef __HELPER_DEBUG__
            NSLog(@"About to delete: %@", objcname);
#endif
            // remove dependencies
            NSString *basedir = [PackageAssistant getPackageBaseDir:objcname];
            NSArray *pdeps = [PackageAssistant getPackageDependencies:objcname];
            NSMutableArray *deps = [NSMutableArray arrayWithArray:pdeps];

            [deps sortUsingComparator:^NSComparisonResult(id a, id b) {
                PackageDependency *depA = a;
                PackageDependency *depB = b;
                NSUInteger aLength = depA.filename.length;
                NSUInteger bLength = depB.filename.length;
                if(aLength == bLength)
                {
                    return NSOrderedSame;
                }
                else if(aLength > bLength)
                {
                    return NSOrderedAscending;
                }
                else
                {
                    return NSOrderedDescending;
                }
            }];
            
            for(PackageDependency *dep in deps)
            {
                sprintf(cmd, "/bin/rm -f \"%s%s\"", basedir.UTF8String, dep.filename.UTF8String);
#ifdef __HELPER_DEBUG__
                NSLog(@"About to execute: %s", cmd);
#endif
                system(cmd);
            }
            
            // remove receipt
            sprintf(cmd, "/bin/rm -rf \"%s\"", [PackageAssistant getPackageFile:objcname].UTF8String);
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
