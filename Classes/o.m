//
//  o.m
//  openfire
//
//  Created by X3N0 on 4/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "o.h"

@implementation o
@synthesize distvar, distvar2, veldistance, fvel, fdist;
@synthesize ftangle, tangle, tangle2;

-(CGPoint)MultiplyVel:(CGPoint)cref :(float)mfact{
	cref = CGPointMake(cref.x * mfact, cref.y * mfact);
	return cref;
}


-(CGPoint)GetAngle:(CGPoint) initialp :(CGPoint) secondp{	
	distvar = ((initialp.x - secondp.x) * (initialp.x - secondp.x));
	distvar2 = ((initialp.y - secondp.y) * (initialp.y - secondp.y));
	if (distvar + distvar2 == 0){
		distvar = 1;
		distvar2 = 3;
	}
	veldistance = sqrt((distvar+distvar2));
	
	distvar = ((fabsf(initialp.x-secondp.x))/veldistance);
	distvar2 = ((fabsf(initialp.y-secondp.y))/veldistance);
	
	if (secondp.x < initialp.x){
		distvar = -distvar;
	}
	if (secondp.y < initialp.y){
		distvar2 = -distvar2;
	}
	
	fvel = CGPointMake(distvar,distvar2);
	
	return fvel;
}

-(float)GetDist: (CGPoint) initialp :(CGPoint) secondp{
	
    distvar = ((initialp.x - secondp.x) * (initialp.x - secondp.x));
    distvar2 = ((initialp.y - secondp.y) * (initialp.y - secondp.y));
	if (distvar + distvar2 == 0){
		distvar = 1;
		distvar2 = 3;
	}
	
    fdist = fabsf(sqrt((distvar+distvar2)));
    return fdist;
	
}


-(void)rotate0: (UIImageView *)ww :(CGPoint)pt{
	tangle2 = [self GetAngle:(ww.center) :(pt)];
	tangle = CGPointMake(tangle2.x,tangle2.y);
	ftangle = atan2( tangle2.y, tangle2.x );	
	ww.transform = CGAffineTransformMakeRotation(ftangle + 1.57);
}



@end
