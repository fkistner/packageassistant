/*
Copyright (c) 2008, PackageAssistant contributors.
All rights reserved. See CONTRIBUTORS file for the list of authors.
This piece of software is distributed under the NEW BSD License.
You should have a LICENSE file along with this distribution
look at it for more information.
*/

#import "Package.h"
#import "PackageLib.h"
#import "PackageDependency.h"

@implementation PackageAssistant

static NSString *receiptsDirectory = @"/Library/Receipts";
static NSString *bomCommand = @"/usr/bin/lsbom";
static NSString *bomFile = @".pkg/Contents/Archive.bom";
static NSString *infoFile = @".pkg/Contents/Info.plist";

+ (NSString*)getPackageFile:(NSString*)name
{
    return [receiptsDirectory stringByAppendingFormat:@"/%@.pkg", name];
}

+ (NSString *)getOutput:(NSString *)cmd arguments:(NSArray *)args
{
    NSTask *task;   
    NSData *result;
    NSString *rawoutput;
    NSPipe *outputPipe;

    // create task and pipe objects
    task = [NSTask new];
    outputPipe = [NSPipe new];

    // setup binary and arguments
    [task setLaunchPath:cmd];
    [task setStandardOutput:outputPipe];
    [task setArguments:args];
    
    // launch task
    [task launch];
    
    result = [[outputPipe fileHandleForReading] readDataToEndOfFile];
    rawoutput = [[NSString alloc] initWithData: result
                encoding: NSASCIIStringEncoding];


    return rawoutput;
}

+ (NSArray*)listPackages
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [fm enumeratorAtPath:receiptsDirectory];
    
    NSString *file;
    NSMutableArray *ret = [NSMutableArray new];

    while(file = [direnum nextObject])
    {
        if ([[file pathExtension] isEqualToString: @"pkg"])
        {
            @autoreleasepool {
                // get the extension out
                NSString *name = [[NSString alloc] initWithString:
                    [file substringToIndex:[file length] - 4]];
                
                // get the base directory (where the package was installed)
                NSString *basedir = [PackageAssistant getPackageBaseDir:name];
                
                // check if it an APPLE package
                bool apple = [PackageAssistant isApplePackage:name];
                
                // create package
                Package *pkg = [[Package alloc] initWithName:name baseDirectory:basedir apple:apple];
                
                // add the package
                [ret addObject:pkg];
            }
        }
    }
    
    return ret;
}

+ (NSMutableArray*)getPackageDependencies:(NSString*)pkg
{
    // dependencies array to be returned
    NSMutableArray *ret = [NSMutableArray new];
    
    // package bom file
    NSString *file = [receiptsDirectory stringByAppendingFormat:@"/%@%@",
        pkg, bomFile];
    
    // arguments to run lsbom
    NSArray *args = [[NSArray alloc] initWithObjects:@"-s", @"-f", file, nil];
    
    // run lsbom and save output
    NSString *output = [[NSString alloc] initWithString:
        [PackageAssistant getOutput:bomCommand arguments:args]];
    
    // separate the output in files
    NSArray *files = [[NSArray alloc] initWithArray:
        [output componentsSeparatedByString:@"\n"]];
    
    // create a dependency object for each file
    int i;
    for(i = 0; i < [files count]; ++i)
    {
        if([[files objectAtIndex:i] length] > 0)
        {
            PackageDependency *dep = [PackageDependency new];
            
            [dep setFilename:[files objectAtIndex:i]];
            [ret addObject:dep];
            
        }
    }
    
    return ret;
}

+ (bool)checkDependencies:(Package*)pkg fast:(bool)f
{
    bool error = [PackageAssistant checkDependenciesArray:[pkg dependencies]
        basedir:[pkg baseDirectory] fast:f];
        
    if(error)
        [pkg setBroken];
        
    return error;
}

+ (bool)checkDependenciesArray:(NSArray*)deps
    basedir:(NSString*)dir fast:(bool)fast
{
    int i;
    bool error = false;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for(i = 0; i < [deps count]; ++i)
    {
        PackageDependency *thisDep = [deps objectAtIndex:i];
        
        // check file existance appending base dir to the dependency
        NSString *filetocheck = [dir
            stringByAppendingString:[thisDep filename]];
        bool exists = [fm fileExistsAtPath:filetocheck];
        
        // set dependency state
        if(exists)
        {
            [thisDep setOk];
        }
        else
        {
            [thisDep setBroken];
            error = true;
            if(fast)
                return error;
        }
    }
    
    return error;
}

+ (NSString*)getPackageBaseDir:(NSString*)name
{
    NSString *plist = [receiptsDirectory stringByAppendingFormat:@"/%@%@",
        name, infoFile];
        
    // load property list
    NSData *plistData = [NSData dataWithContentsOfFile:plist];

    // parse property list
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary *plistdic;
    plistdic = [NSPropertyListSerialization propertyListFromData:plistData
                                    mutabilityOption:NSPropertyListImmutable
                                    format:&format
                                    errorDescription:&error];
    if(!plist)
    {
        NSLog(@"%@", error);
    }

    NSString *tmpdir = [plistdic objectForKey:@"IFPkgRelocatedPath"];
    return [tmpdir substringWithRange:NSMakeRange(1, [tmpdir length] - 2)];
}

+ (bool)isApplePackage:(NSString*)name
{
    NSString *plist = [receiptsDirectory stringByAppendingFormat:@"/%@%@",
        name, infoFile];
        
    // load property list
    NSData *plistData = [NSData dataWithContentsOfFile:plist];

    // parse property list
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary *plistdic;
    plistdic = [NSPropertyListSerialization propertyListFromData:plistData
                                    mutabilityOption:NSPropertyListImmutable
                                    format:&format
                                    errorDescription:&error];
    if(!plist)
    {
        NSLog(@"%@", error);
    }

    NSString *bundleid = [plistdic objectForKey:@"CFBundleIdentifier"];
    return [bundleid hasPrefix:@"com.apple."];
}

@end
