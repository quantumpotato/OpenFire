//
//  openfireipadAppDelegate.h
//  openfireipad
//
//  Created by X3N0 on 7/22/10.
//  Copyright Rage Creations 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class openfireipadViewController;

@interface openfireipadAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    openfireipadViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet openfireipadViewController *viewController;

@end

