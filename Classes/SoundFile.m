//
//  SoundFile.m
//  openfireipad
//
//  Created by X3N0 on 8/31/10.
//  Copyright 2010 Rage Creations. All rights reserved.
//

#import "SoundFile.h"


@implementation SoundFile

@synthesize soundID,tick,tickreset;

-(id)init{
	if (self = [super init]){
		self.tick = 0;	
	}
	return self;
}

@end
