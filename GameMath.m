//
//  GameMath.m
//  openfireipad
//
//  Created by X3N0 on 8/17/10.
//  Copyright 2010 Rage Creations. All rights reserved.
//

#import "GameMath.h"


@implementation GameMath

+(CGPoint)MultiplyVel:(CGPoint)cref :(float)mfact{
	cref = CGPointMake(cref.x * mfact, cref.y * mfact);
	return cref;
}

+(CGPoint)GetAngle:(CGPoint) initialp :(CGPoint) secondp{	
	float	distvar = ((initialp.x - secondp.x) * (initialp.x - secondp.x));
	float	distvar2 = ((initialp.y - secondp.y) * (initialp.y - secondp.y));
	if (distvar + distvar2 == 0){
		distvar = 1;
		distvar2 = 3;
	}
	float	veldistance = sqrt((distvar+distvar2));
	
	distvar = ((fabsf(initialp.x-secondp.x))/veldistance);
	distvar2 = ((fabsf(initialp.y-secondp.y))/veldistance);
	
	if (secondp.x < initialp.x){
		distvar = -distvar;
	}
	if (secondp.y < initialp.y){
		distvar2 = -distvar2;
	}
	
	CGPoint	fvel = CGPointMake(distvar,distvar2);
	
	return fvel;
}

+(CGPoint)CombineVel:(CGPoint)v1 :(CGPoint)v2{
	v1 = CGPointMake(v1.x+v2.x,v1.y+v2.y);
	return v1;
}

+(float)GetDist:(CGPoint) initialp :(CGPoint) secondp{
	
	float    distvar = ((initialp.x - secondp.x) * (initialp.x - secondp.x));
	float    distvar2 = ((initialp.y - secondp.y) * (initialp.y - secondp.y));
	if (distvar + distvar2 == 0){
		distvar = 1;
		distvar2 = 3;
	}
	
	float    fdist = fabsf(sqrt((distvar+distvar2)));
    return fdist;
}


+(void)rotate0: (UIImageView *)ww :(CGPoint)pt{
	CGPoint	tangle2 = [self GetAngle:(ww.center) :(pt)];
	float	ftangle = atan2( tangle2.y, tangle2.x );	
	ww.transform = CGAffineTransformMakeRotation(ftangle + 1.57);
}

@end
