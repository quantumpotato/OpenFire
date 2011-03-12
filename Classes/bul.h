//
//  bul.h
//  openfire
//
//  Created by X3N0 on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface bul : NSObject {

	int index;
	int k, who;
	CGPoint l, vel;
	int animf, animfmax;
	int pow, radius;
	
}

@property(nonatomic) int index;
@property(nonatomic) int k;
@property(nonatomic) int who;
@property(nonatomic) CGPoint l;
@property(nonatomic) CGPoint vel;
@property(nonatomic) int animf;
@property(nonatomic) int animfmax;
@property(nonatomic) int pow;
@property(nonatomic) int radius;

@end
