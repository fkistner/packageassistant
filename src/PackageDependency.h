/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import <Cocoa/Cocoa.h>

@interface PackageDependency : NSObject
{
@private
    // filaname
    NSString *_filename;
    
    // state (DependencyState)
    bool _broken;
}

- (id)initWithFilename:(NSString*)name andState:(bool)broken;

@property (readonly,retain,nonatomic) NSString *filename;
@property (readonly,assign,nonatomic) bool broken;

@end
