//
//  main.m
//  DisplayInCLI
//
//  Created by Aparna Joshi on 29/09/20.
//  Copyright © 2020 HP Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayCore.h"


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        [[DisplayCore sharedInstance] startDisplayCore];
        NSApplicationLoad();
        CFRunLoopRun();
    }
    return 0;
}
