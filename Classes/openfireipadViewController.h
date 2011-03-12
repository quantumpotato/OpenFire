//
//  openfireipadViewController.h
//  openfireipad
//
//  Created by X3N0 on 7/22/10.
//  Copyright Rage Creations 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bul.h"
#import "o.h"
#import "p.h"
#import <AudioToolbox/AudioServices.h>
#import "SoundFile.h"

@interface openfireipadViewController : UIViewController {
	NSMutableArray *bry;
	NSMutableArray *bdry;
	NSMutableArray *pry;
	NSMutableArray *pdry;
	
	NSMutableArray *plasmaref;
	NSMutableArray *rocketref;
	
	NSTimer *myTimer;
	
	int gameRate;
	
	o *myo;
	
	int randint, myint, myint2;
	float randf, randf2;
	
	float distvar, distvar2, veldistance, ftangle, fdist;
	CGPoint fvel, tangle, tangle2;
	
	//gamestate
	int gamestate;
	int gamestatetick;
	
	
	CGPoint gestureStartPoint, currentPosition;
	
	//weapons
	int weapon1wide, weapon2wide;
	int weapon1dist, weapon2dist;
	int weapon1repeatreset,  weapon2repeatreset;
	float weapon1speed, weapon2speed;
	int weapon1freeze, weapon2freeze;
	
	int hpreset, shipreset;
	int p1ships, p2ships;
	
	int nb;
	
	float speed0, speed1, speed2;
	
	int maxbullets;
	
	int p1hits, p2hits;
	int p1kills, p2kills;

	UILabel *p1label;
	UILabel *p2label;
	UILabel *p11label;
	UILabel *p22label;
	UILabel *p111label;
	UILabel *p222label;
	
	UILabel *killlabel1;
	UILabel *killlabel2;
	
	int p1dir, p1fire;
	int p2dir, p2fire;
	
	float buttondist;
	
	CGPoint p1FlyL, p1FlyR, p1shootA, p1shootB;
	CGPoint p2FlyL, p2FlyR, p2shootA, p2shootB;	
	
	CGPoint p1movpoint, p1firepoint;
	CGPoint p2movpoint, p2firepoint;	
	
	float deg90;

	int minmove;
	
	NSMutableArray *explosionrefarray;
	NSMutableArray *plasmadispersearray;
	
	NSMutableArray *shiprefarray;
	NSMutableArray *ship2refarray;	

	NSMutableArray *thrustdrawarray;
	NSMutableArray *thrustrefarray;
	
	UIImageView *shipexhaust1;
	UIImageView *shipexhaust2;

	NSMutableArray *soundsarray;
	
	int maxshipf;
	
	
	UIProgressView *healthbar1;
	UIProgressView *healthbar2;
	
	UIButton *rematchButton;
	UIButton *exitButton;
}

@property(nonatomic,retain) IBOutlet UIButton *rematchButton;
@property(nonatomic,retain) IBOutlet UIButton *exitButton;

@property(nonatomic,retain) IBOutlet UIProgressView *healthbar1;
@property(nonatomic,retain) IBOutlet UIProgressView *healthbar2;



@property(nonatomic,retain) o *myo;

@property(nonatomic,retain) NSMutableArray *bry;
@property(nonatomic,retain) NSMutableArray *bdry;
@property(nonatomic,retain) NSMutableArray *pry;
@property(nonatomic,retain) NSMutableArray *pdry;
@property(nonatomic,retain) NSMutableArray *plasmaref;
@property(nonatomic,retain) NSMutableArray *rocketref;
@property(nonatomic,retain) NSMutableArray *plasmadispersearray;
@property(nonatomic,retain) NSMutableArray *explosionrefarray;

@property(nonatomic,retain) NSMutableArray *shiprefarray;
@property(nonatomic,retain) NSMutableArray *ship2refarray;
@property(nonatomic,retain) NSMutableArray *thrustdrawarray;
@property(nonatomic,retain) NSMutableArray *thrustrefarray;
@property(nonatomic,retain) NSMutableArray *soundsarray;
@property(nonatomic,retain) UIImageView *shipexhaust1;
@property(nonatomic,retain) UIImageView *shipexhaust2;

-(void)checkplayerstate;
-(void)readygame;
-(void)countdown;
-(void)resetships;

-(IBAction)rematchButtonPressed:(id)sender;
-(IBAction)exitButtonPressed:(id)sender;

@end

