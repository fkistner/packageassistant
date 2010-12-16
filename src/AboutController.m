#import "BuildInformation.h"
#import "AboutController.h"

@implementation AboutController

- (IBAction)aboutOpen:(id)sender
{
    [NSApp runModalForWindow:aboutWindow];
}

- (IBAction)aboutClose:(id)sender
{
    [NSApp abortModal];
    [aboutWindow close];
}

- (NSString*)credits
{
    return [[[NSBundle mainBundle] resourcePath]
        stringByAppendingString:@"/credits.rtf"];
}

- (NSString*)version
{
    // setup version text
    NSString *bundlver = [BuildInformation getBundleVersion];
    NSString *revnum = [BuildInformation getSourceRevision];
    return [NSString stringWithFormat:@"Version %@r%@", bundlver, revnum];
}

@end
