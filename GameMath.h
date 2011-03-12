//
//  GameMath.h
//  openfireipad
//
//  Created by X3N0 on 8/17/10.
//  Copyright 2010 Rage Creations. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameMath : NSObject {

}

+(CGPoint)MultiplyVel:(CGPoint)cref :(float)mfact;
+(CGPoint)GetAngle:(CGPoint) initialp :(CGPoint) secondp;
+(CGPoint)CombineVel:(CGPoint)v1 :(CGPoint)v2;
+(float)GetDist: (CGPoint) initialp :(CGPoint) secondp;
+(void)rotate0: (UIImageView *)ww :(CGPoint)pt;

@end
