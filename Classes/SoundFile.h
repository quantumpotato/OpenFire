//
//  SoundFile.h
//  openfireipad
//
//  Created by X3N0 on 8/31/10.
//  Copyright 2010 Rage Creations. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface SoundFile : NSObject {
	NSNumber *soundID;
	int tick;
	int tickreset;
	
}

@property(nonatomic,retain) NSNumber *soundID;
@property(nonatomic) int tick;
@property(nonatomic) int tickreset;

@end
