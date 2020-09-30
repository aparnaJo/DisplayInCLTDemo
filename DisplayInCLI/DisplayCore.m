//
//  DisplayCore.m
//  DisplayInCLI
//
//  Created by Aparna Joshi on 30/09/20.
//  Copyright © 2020 HP Inc. All rights reserved.
//

#import "DisplayCore.h"
#import <IOKit/IOKitLib.h>
#import <Cocoa/Cocoa.h>
#import <ApplicationServices/ApplicationServices.h>

@implementation DisplayCore
+ (DisplayCore *)sharedInstance {
    
    static DisplayCore* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DisplayCore alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    return self;
}

- (void)startDisplayCore {
    [self registerForDisplayChangeNotifications:self];
    NSLog(@"Fetching currently connected displays...");
    NSArray *availableDisplays = [self getAvailableDisplays];
    NSLog(@"Available displays :%@",availableDisplays);
}

- (NSArray *)getAvailableDisplays {
    
    /*
     This method gets the details of Displays connected at the moment.
     */
    NSMutableArray *availableDisplays = [[NSMutableArray alloc] init];
    
    uint32_t displayCount;
    
    /*
     First we need count of total available displays.
     */
    CGGetOnlineDisplayList(INT_MAX, NULL, &displayCount);
    
    /*
     Here we create pointer to total available display's display ids.
     */
    CGDirectDisplayID onlineDisplays[displayCount];
    
    /*
     Here we pass that pointer to get the display ids of available displays.
     */
    CGGetOnlineDisplayList(INT_MAX, onlineDisplays, &displayCount);
    
    NSLog(@"Number of displays found connected :%d.",displayCount);

    for(uint32_t i = 0; i < displayCount; i++)
    {
        CGDirectDisplayID displayId = onlineDisplays[i];
        [availableDisplays addObject:[NSNumber numberWithUnsignedInt:displayId]];
    }
    return availableDisplays;
}

/*
This method will register DisplayHelper class to get the notification if there is/are any external display connects/disconnects.
*/
- (void)registerForDisplayChangeNotifications:(id)object {

    CGError error = CGDisplayRemoveReconfigurationCallback(ReconfigurationCallBack, (__bridge void * _Nullable)(object));

       if (error != kCGErrorSuccess) {
           NSLog(@"Error while removing Display configuration callback :%d",error);
       }

    error = CGDisplayRegisterReconfigurationCallback(ReconfigurationCallBack,(__bridge void * _Nullable)(object));

    if (error != kCGErrorSuccess) {
        NSLog(@"Error while registering Display configuration callback :%d",error);
    }

    NSLog(@"Successfully regsistered for Display plug/unplug event.");
}

/*
This method will de-register DisplayHelper class to get the notification if there is/are any external display connects/disconnects.
*/
- (void)deregisterForDisplayChangeNotifications:(id)object {

    CGError error = CGDisplayRemoveReconfigurationCallback(ReconfigurationCallBack, (__bridge void * _Nullable)(object));

    if (error != kCGErrorSuccess) {
        NSLog(@"Error while removing Display configuration callback :%d",error);
    }
    NSLog(@"Successfully de-regsistered for Display plug/unplug event.");
}

void ReconfigurationCallBack (CGDirectDisplayID display, CGDisplayChangeSummaryFlags flags, void *userInfo) {
    
    @try {
        if (flags & kCGDisplayAddFlag) {
            // display has been added
            NSLog(@"Display has been added :%d",display);
        }
        else if (flags & kCGDisplayRemoveFlag) {
            // display has been removed
            NSLog(@"Display has been removed: %d",display);
        }
    } @catch (NSException *exception) {
        NSLog(@"Caught exception in display plug/unplug callback :%@",[exception reason]);
    }
    
}

- (void)dealloc {
    [self deregisterForDisplayChangeNotifications:self];
}
@end
