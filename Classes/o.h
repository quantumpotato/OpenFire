//
//  o.h
//  openfire
//
//  Created by X3N0 on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface o : NSObject {
	float distvar, distvar2, veldistance, ftangle, fdist;
	CGPoint fvel, tangle, tangle2;
}

@property(nonatomic) float distvar;
@property(nonatomic) float distvar2;
@property(nonatomic) float ftangle;
@property(nonatomic) float veldistance;
@property(nonatomic) float fdist;
@property(nonatomic) CGPoint fvel;
@property(nonatomic) CGPoint tangle;
@property(nonatomic) CGPoint tangle2;

-(CGPoint)MultiplyVel:(CGPoint)cref :(float)mfact;
-(CGPoint)GetAngle:(CGPoint) initialp :(CGPoint) secondp;
-(void)rotate0: (UIImageView *)ww :(CGPoint)pt;
-(float)GetDist: (CGPoint) initialp :(CGPoint) secondp;

@end
