//
//  UCSeatSelector.h
//  UCSeatSelector
//
//  Created by anonymous on 27/8/2562 BE.
//  Copyright © 2562 anonymous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCSeatSelector.h"
#import "UCSeatItem.h"
#import "UCSeatsPicker.h"
#import "UCSeatsPickerIndexView.h"

// Implementation of the framework version numbers
double UCSeatSelectorVersionNumber = 1.0;
const unsigned char UCSeatSelectorVersionString[] = "1.0.0";

// This is primarily an umbrella framework, so most functionality is in the individual components
// If there's any framework-level initialization that needs to happen, it would go here

@implementation UCSeatSelector

// You can add framework-level utility methods here if needed
+ (NSString *)frameworkVersion {
    return [NSString stringWithUTF8String:(const char *)UCSeatSelectorVersionString];
}

// Initialization method if needed
+ (void)initialize {
    if (self == [UCSeatSelector class]) {
        // Any one-time framework initialization code here
        NSLog(@"UCSeatSelector framework initialized. Version: %@", [self frameworkVersion]);
    }
}

@end