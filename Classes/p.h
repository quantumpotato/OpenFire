//
//  p.h
//  openfire
//
//  Created by X3N0 on 4/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface p : NSObject {
	int k;
	int ships;
	float hp;
	CGPoint l, vel, mstart, mtar;
	float ty;
	float speed;
	int firestate, repeat, repeatreset;
	int weapon;
	float wvspeed;
	int freezetime;
	
	int mdown, fdown;
	
	int pdir, pfire;
	CGPoint pFlyL, pFlyR, pshootA, pshootB;
	CGPoint pmovpoint, pfirepoint;
	
	int canimf, maxanimf;
	int cthrustanimf, thrustmaxanimf;
	int direction;
	
	int thrustdelay, thrustdelayreset;

	BOOL placed;
}

@property(nonatomic) BOOL placed;

@property(nonatomic) int ships;
@property(nonatomic) int thrustdelay;
@property(nonatomic) int thrustdelayreset;

@property(nonatomic) int cthrustanimf;
@property(nonatomic) int thrustmaxanimf;
@property(nonatomic) int canimf;
@property(nonatomic) int maxanimf;
@property(nonatomic) int direction;

@property(nonatomic) int mdown;
@property(nonatomic) int fdown;

@property(nonatomic) int pdir;
@property(nonatomic) int pfire;
@property(nonatomic) CGPoint pFlyL;
@property(nonatomic) CGPoint pFlyR;
@property(nonatomic) CGPoint pshootA;
@property(nonatomic) CGPoint pshootB;
@property(nonatomic) CGPoint pmovpoint;
@property(nonatomic) CGPoint pfirepoint;

@property(nonatomic) int freezetime;
@property(nonatomic) float ty;
@property(nonatomic) int k;
@property(nonatomic) float hp;
@property(nonatomic) CGPoint l;
@property(nonatomic) CGPoint vel;
@property(nonatomic) CGPoint mstart;
@property(nonatomic) CGPoint mtar;
@property(nonatomic) float speed;
@property(nonatomic) int firestate;
@property(nonatomic) int repeat;
@property(nonatomic) int repeatreset;
@property(nonatomic) int weapon;
@property(nonatomic) float wvspeed;

@end
