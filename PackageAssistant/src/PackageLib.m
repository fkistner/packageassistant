#import "Package.h"
#import "PackageLib.h"
#import "PackageDependency.h"

@implementation PackageAssistant

- (id)init
{
    if(self = [super init])
    {
        receiptsDirectory = @"/Library/Receipts";
        bomCommand = @"/usr/bin/lsbom";
        bomFile = @".pkg/Contents/Archive.bom";
    }
    
    return self;
}

- (NSArray*)listPackages
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *direnum = [fm enumeratorAtPath:receiptsDirectory];
    
    NSString *file;
    NSMutableArray *ret = [NSMutableArray new];

    while(file = [direnum nextObject])
    {
        if ([[file pathExtension] isEqualToString: @"pkg"])
        {
            NSAutoreleasePool *pool = [NSAutoreleasePool new];
        
            // get the extension out
            NSString *name = [[NSString alloc] initWithString:
                [file substringToIndex:[file length] - 4]];
            
            // create package
            Package *pkg = [Package new];
            
            // set name
            [pkg setName:name];
            
            // add the package
            [ret addObject:pkg];
            
            // cleanup
            [name release];
            [pkg release];
            [pool release];
        }
    }
    
    return [ret autorelease];
}

- (NSMutableArray*)getPackageDependencies:(NSString*)pkg
{
    // dependencies array to be returned
    NSMutableArray *ret = [NSMutableArray new];
    
    // package bom file
    NSString *file = [[NSString alloc] initWithFormat:@"%@/%@%@",
        receiptsDirectory, pkg, bomFile];
    
    // arguments to run lsbom
    NSArray *args = [[NSArray alloc] initWithObjects:@"-s", @"-f", file, nil];
    
    // run lsbom and save output
    NSString *output = [[NSString alloc] initWithString:
        [PackageAssistant getOutput:bomCommand arguments:args]];
    
    // separate the output in files
    NSArray *files = [[NSArray alloc] initWithArray:
        [output componentsSeparatedByString:@"\n"]];
    
    // clean
    [file release];
    [args release];
    [output release];
    
    // create a dependency object for each file
    int i;
    for(i = 0; i < [files count]; ++i)
    {
        if([[files objectAtIndex:i] length] > 0)
        {
            PackageDependency *dep = [PackageDependency new];
            
            [dep setFilename:[files objectAtIndex:i]];
            [ret addObject:dep];
            
            [dep release];
        }
    }
    
    // cleanup
    [files release];
    
    return [ret autorelease];
}

- (bool)checkDependencies:(NSArray*)deps
{    
    int i;
    bool error = false;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for(i = 0; i < [deps count]; ++i)
    {
        PackageDependency *thisDep = [deps objectAtIndex:i];
        
        // check file existance
        NSString *file = [[NSString alloc] initWithString:
            [[thisDep filename] substringFromIndex:1]];
        bool exists = [fm fileExistsAtPath:file];
        
        // clean file
        [file release];
        
        // set dependency state
        if(exists)
        {
            [thisDep setOk];
        }
        else
        {
            [thisDep setBroken];
            error = true;
        }
    }
    
    return error;
}

- (bool)fastCheckDependencies:(NSArray*)deps
{    
    int i;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for(i = 0; i < [deps count]; ++i)
    {
        PackageDependency *thisDep = [deps objectAtIndex:i];
        
        // check file existance
        NSString *file = [[NSString alloc] initWithString:
            [[thisDep filename] substringFromIndex:1]];
        bool exists = [fm fileExistsAtPath:file];
        
        // clean file
        [file release];
        
        if(!exists)
        {
            return false;
        }
    }
    
    return true;
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

    [task release];
    [outputPipe release];

    return [rawoutput autorelease];
}

@end
