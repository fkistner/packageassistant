//
//  BOM.h
//  PackageAssistant
//
//  Created by Florian Kistner on 14.12.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BOM <NSObject>

- (id <NSFastEnumeration>)directoryEnumerator;
- (unsigned long long)fileCount;

@end
