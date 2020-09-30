//
//  DisplayCore.h
//  DisplayInCLI
//
//  Created by Aparna Joshi on 30/09/20.
//  Copyright © 2020 HP Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DisplayCore : NSObject
+ (DisplayCore *)sharedInstance;
- (void)startDisplayCore;
@end

NS_ASSUME_NONNULL_END
