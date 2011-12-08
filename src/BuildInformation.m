/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "BuildInformation.h"

NSString *build_revision = @"$Revision$";
NSString *build_id = @"$Id$";

@implementation BuildInformation

+ (NSString*) getBundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary]
        objectForKey:@"CFBundleVersion"];
}

+ (NSString*) getSourceRevision
{
    //NSString *revnum = [build_revision substringFromIndex:11];
    //return [revnum substringToIndex:([revnum length] - 2)];
    return @"git";
}

@end
