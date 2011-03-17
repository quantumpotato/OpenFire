//
//  openfireipadViewController.m
//  openfireipad
//
//  Created by X3N0 on 7/22/10.
//  Copyright Rage Creations 2010. All rights reserved.
//

//ships
//plasma
//rockets

#define soundIndexPlasmaStart 0
#define soundIndexPlasmaMax 11
#define soundIndexRocketStart 12
#define soundIndexRocketMax 18
#define soundIndexPlasmaHitStart 19
#define soundIndexPlasmaHitMax 25
#define soundIndexRocketHitStart 26
#define soundIndexRocketHitMax 32
#define soundIndexShipExplodeStart 33
#define soundIndexShipExplodeMax 34

#import "openfireipadViewController.h"
#import "GameMath.h"

@interface Sound : NSObject
{
    SystemSoundID handle;
}

// Path is relative to the resources dir.
- (id) initWithPath: (NSString*) path;
- (void) play;

@end
//
@implementation Sound

- (id) initWithPath: (NSString*) path
{
    [super init];
	
	
   // NSString *const resourceDir = [[NSBundle mainBundle] resourcePath];
	
   // NSString *const fullPath = [resourceDir stringByAppendingPathComponent:path];
	
//    NSURL *const url = [NSURL fileURLWithPath:fullPath];
    
//    OSStatus errcode = AudioServicesCreateSystemSoundID((CFURLRef) url, &handle);
  //  NSAssert1(errcode == 0, @"Failed to load sound: %@", path);
    return self;
}

- (void) dealloc
{
    AudioServicesDisposeSystemSoundID(handle);
    [super dealloc];
}

- (void) play
{
    AudioServicesPlaySystemSound(handle);
}

@end


@implementation openfireipadViewController
@synthesize pry, pdry, bry, bdry, plasmaref, rocketref;
@synthesize myo;
@synthesize explosionrefarray, plasmadispersearray;
@synthesize shiprefarray, ship2refarray, thrustrefarray, thrustdrawarray;
@synthesize shipexhaust1, shipexhaust2, soundsarray;
@synthesize healthbar1, healthbar2;
@synthesize rematchButton, exitButton;

-(void)setIntroText{
	p1label.text = @"Drag finger left and right to move";
	p11label.text = @"Drag finger up and down to change weapons";
	p111label.text = @"Destroy your opponent's ships to win!";
	p2label.text = @"Drag finger left and right to move";
	p22label.text = @"Drag finger up and down to change weapons";
	p222label.text = @"Destroy your opponent's ships to win!";
	p1label.alpha = 1;
	p11label.alpha = 1;
	p111label.alpha = 1;
	p2label.alpha = 1;
	p22label.alpha = 1;
	p222label.alpha = 1;	
	p22label.textColor = [UIColor whiteColor];
	p11label.textColor = [UIColor whiteColor];	
}

-(IBAction)rematchButtonPressed:(id)sender{
	killlabel2.alpha = 1;
	killlabel1.alpha = 1;
	killlabel1.text = [NSString stringWithFormat:@"%d - Ships - %d",p1ships, p1ships];
	killlabel2.text = [NSString stringWithFormat:@"%d - Ships - %d",p2ships, p2ships];
	[self setIntroText];
	[self resetships];
	[self countdown];
    
}

-(IBAction)exitButtonPressed:(id)sender{
	
}


-(void)initializearrays{
	self.bry = [[NSMutableArray alloc] initWithCapacity:maxbullets];
	bul *newb = [[bul alloc] init];
	newb.k = -1;
	newb.l = CGPointMake(5000,500);
	[bry addObject:newb];
	[newb release];
	
	for (int i = 1; i <= maxbullets;i++){
		newb = [[bul alloc] init];
		newb.k = -1;
		newb.l = CGPointMake(500,5000);
		[bry addObject:newb];
		[newb release];
	}
	
	self.pry = [[NSMutableArray alloc] initWithCapacity:1];
	p *np = [[p alloc] init];
	np.k = -1;
	np.l = CGPointMake(500,500);
	[pry addObject:np];
	[np release];
	
	np = [[p alloc] init];
	np.k = -1;
	np.l = CGPointMake(500,500);
	[pry addObject:np];
	[np release];
	
	self.bdry = [[NSMutableArray alloc] initWithCapacity:maxbullets];
	UIImageView *ndb = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BlueOrbRZ" ofType:@"png"]]];
	ndb.center = CGPointMake(5000,500);
	[self.view addSubview:ndb];
	[bdry addObject:ndb];
	[ndb release];
	
	for (int i = 1; i <= maxbullets;i++){
		ndb = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BlueOrbRZ" ofType:@"png"]]];
		ndb.center = CGPointMake(5000,500);
		[self.view addSubview:ndb];
		[bdry addObject:ndb];
		[ndb release];
	}
	
	self.pdry = [[NSMutableArray alloc] initWithCapacity:2];
	UIImageView *ndp = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CRShip1_30_1" ofType:@"png"]]];
	ndp.center = CGPointMake(500,500);	
	[self.view addSubview:ndp];
	[pdry addObject:ndp];
	[ndp release];
	
	ndp = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CRShip2_30_1" ofType:@"png"]]];
	ndp.center = CGPointMake(100,100);
	[self.view addSubview:ndp];
	[pdry addObject:ndp];
	[ndp release];
	
	self.plasmaref = [[NSMutableArray alloc] initWithCapacity:62];
	
	UIImageView *plas1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"plasma0.png"]]];
	plas1.center = CGPointMake(500,500);
	[plasmaref addObject:plas1];
	[plas1 release];
	
	plas1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"plasma0.png"]]];
	plas1.center = CGPointMake(500,500);
	[plasmaref addObject:plas1];
	[plas1 release];
	
	plas1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"plasma1.png"]]];
	plas1.center = CGPointMake(500,500);
	[plasmaref addObject:plas1];
	[plas1 release];
	
	
	plas1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"plasma2.png"]]];
	plas1.center = CGPointMake(500,500);
	[plasmaref addObject:plas1];
	[plas1 release];
	
	for (int i = 4; i < 60; i++){
		plas1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"plasma%d.png",i]]];
		plas1.center = CGPointMake(500,500);
		[plasmaref addObject:plas1];
		[plas1 release];
	}
	
	
	self.rocketref = [[NSMutableArray alloc] initWithCapacity:31];
	
	UIImageView *rock1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MissleR1_00.png"]]];	
	rock1.center = CGPointMake(500,500);
	[rocketref addObject:rock1];
	[rock1 release];
	
	for (int i = 1; i <= 9; i++){	
		rock1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MissleR1_0%d.png",i]]];		
		rock1.center = CGPointMake(500,500);
		[rocketref addObject:rock1];
		[rock1 release];
	}
	
	for (int i = 10; i < 29; i++){	
		rock1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MissleR1_%d.png",i]]];		
		rock1.center = CGPointMake(500,500);
		[rocketref addObject:rock1];
		[rock1 release];
	}
	
	self.explosionrefarray = [[NSMutableArray alloc] initWithCapacity:31];
	UIImageView *nex = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"explosion0.png"]]];
	nex.center = CGPointMake(500,500);
	[explosionrefarray addObject:nex];
	
	for (int i = 1; i < 24; i++){
		nex = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%d.png",i]]];
		nex.center = CGPointMake(500,500);
		[explosionrefarray addObject:nex];
		[nex release];
	}
	nex = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion0.png"]]];
	nex.center = CGPointMake(500,500);
	[explosionrefarray addObject:nex];
	[nex release];
	
	self.plasmadispersearray = [[NSMutableArray alloc] initWithCapacity:62];
	UIImageView *pburst = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"PBDisperse_00.png"]]];	
	pburst.center = CGPointMake(500,500);
	[plasmadispersearray addObject:pburst];
	[pburst release];
	
	for (int i = 1; i <= 9; i++){
		
		pburst = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"PBDisperse_0%d.png",i]]];	
		pburst.center = CGPointMake(500,500);
		[plasmadispersearray addObject:pburst];
		[pburst release];
	}
	for (int i = 10; i <= 59; i++){
		
		pburst = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"PBDisperse_%d.png",i]]];	
		pburst.center = CGPointMake(500,500);
		[plasmadispersearray addObject:pburst];
		[pburst release];
	}
	
	
	self.shiprefarray = [[NSMutableArray alloc] initWithCapacity:70];
	UIImageView *sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Ship1_Bank1_00.png"]]];
	sship.center = CGPointMake(500,500);
	[shiprefarray addObject:sship];
	[sship release];
	
	sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Ship1_Bank1_00.png"]]];
	sship.center = CGPointMake(500,500);
	[shiprefarray addObject:sship];
	[sship release];
	
	for (int i = 1; i<=9;i++){
		sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Ship1_Bank1_0%d.png",i]]];
		sship.center = CGPointMake(500,500);
		[shiprefarray addObject:sship];
		[sship release];		
	}
	for (int i = 10; i<=29;i++){
		sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Ship1_Bank1_%d.png",i]]];
		sship.center = CGPointMake(500,500);
		[shiprefarray addObject:sship];
		[sship release];		
	}
	for (int i = 30; i<=59;i++){
		sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Ship1_Bank2_%d.png",i]]];
		sship.center = CGPointMake(500,500);
		[shiprefarray addObject:sship];
		[sship release];		
	}
	sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Ship1_Bank2_59.png"]]];
	sship.center = CGPointMake(500,500);
	[shiprefarray addObject:sship];
	[sship release];			
	sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Ship1_Bank2_59.png"]]];
	sship.center = CGPointMake(500,500);
	[shiprefarray addObject:sship];
	[sship release];				
	
	self.ship2refarray = [[NSMutableArray alloc] initWithCapacity:70];
	sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Shp2_Bank1_00.png"]]];
	sship.center = CGPointMake(500,500);
	[shiprefarray addObject:sship];
	[sship release];
	
	sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Shp2_Bank1_00.png"]]];
	sship.center = CGPointMake(500,500);
	[shiprefarray addObject:sship];
	[sship release];	
	
	
	for (int i = 1; i<=9;i++){
		sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Shp2_Bank1_0%d.png",i]]];
		sship.center = CGPointMake(500,500);
		[ship2refarray addObject:sship];
		[sship release];		
	}
	for (int i = 10; i<=29;i++){
		sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Shp2_Bank1_%d.png",i]]];
		sship.center = CGPointMake(500,500);
		[ship2refarray addObject:sship];
		[sship release];		
	}
	for (int i = 30; i<=59;i++){
		sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Shp2_Bank2_%d.png",i]]];
		sship.center = CGPointMake(500,500);
		[ship2refarray addObject:sship];
		[sship release];		
	}
	
	sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Shp2_Bank2_59.png"]]];
	sship.center = CGPointMake(500,500);
	[ship2refarray addObject:sship];
	[sship release];	
	
	sship = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[NSString stringWithFormat:@"Shp2_Bank2_59.png"]]];
	sship.center = CGPointMake(500,500);
	[ship2refarray addObject:sship];
	[sship release];	
	
	maxshipf = 29;
	
	
	self.shipexhaust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exhaustA0.png"]];	
	self.shipexhaust2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"exhaustA0.png"]];
	[self.view addSubview:self.shipexhaust1];
	[self.view addSubview:self.shipexhaust2];
	
	
	
	self.thrustrefarray = [[NSMutableArray alloc] initWithCapacity:77];
	UIImageView *thrust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"exhaustA0.png"]]];
	thrust1.center = CGPointMake(5000,500);
	[thrustrefarray addObject:thrust1];
	[thrust1 release];
	
	
	
	for (int i = 1; i <= 29; i++){
		thrust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"exhaustA%d.png",i]]];
		thrust1.center = CGPointMake(500,500);
		[thrustrefarray addObject:thrust1];
		[thrust1 release];
	}
	
	thrust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"exhaustB0.png"]]];
	thrust1.center = CGPointMake(500,500);
	[thrustrefarray addObject:thrust1];
	[thrust1 release];
	
	
	for (int i = 1; i <= 15; i++){
		thrust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"exhaustB%d.png",i]]];
		thrust1.center = CGPointMake(500,500);
		[thrustrefarray addObject:thrust1];
		[thrust1 release];
	}
	
	//45 above
	thrust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ExhDispR1_00.png"]]];	
	thrust1.center = CGPointMake(500,500);
	[thrustrefarray addObject:thrust1];
	[thrust1 release];
	
	for (int i = 1; i <= 9; i++){
		thrust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ExhDispR1_0%d.png",i]]];		
		thrust1.center = CGPointMake(500,500);
		[thrustrefarray addObject:thrust1];
		[thrust1 release];
	}
	
	for (int i = 10; i <= 28; i++){
		thrust1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ExhDispR1_%d.png",i]]];		
		thrust1.center = CGPointMake(500,500);
		[thrustrefarray addObject:thrust1];
		
		[thrust1 release];
	}
}

-(void)createSoundWithPath:(NSString *)path{
	SystemSoundID staticbeamid;
	NSString *beamPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",path] ofType:@"caf"];	
	CFURLRef beamURL = (CFURLRef ) [NSURL fileURLWithPath:beamPath];
	AudioServicesCreateSystemSoundID (beamURL, &staticbeamid);
	
	SoundFile *sf = [[SoundFile alloc] init];
	sf.soundID = [NSNumber numberWithInt:staticbeamid];
	sf.tickreset = 3 * gameRate;
	
	[self.soundsarray addObject:sf];
	
}

-(void)initializesounds{
	
	self.soundsarray = [NSMutableArray array];
	
	NSLog(@"initializing sounds");
	
	for (int i = soundIndexPlasmaStart; i <= soundIndexPlasmaMax; i++){
		[self createSoundWithPath:@"ElectricFlutters01"];
	}
	
	for (int i = soundIndexRocketStart; i <= soundIndexRocketMax; i++){
		[self createSoundWithPath:@"Whoosh03"];	
	}
	
	
	for (int i = soundIndexPlasmaHitStart; i <= soundIndexPlasmaHitMax; i++){
		[self createSoundWithPath:@"staticbeam09v"];
	}
	
	for (int i = soundIndexRocketHitStart; i <= soundIndexRocketHitMax; i++){
		[self createSoundWithPath:@"Explo Classic"];
	}
	
	for (int i = soundIndexShipExplodeStart; i <= soundIndexShipExplodeMax; i++){
		[self createSoundWithPath:@"explosion"];
	}
	
	
	
	SystemSoundID testbeam;
	NSString *beamPath = [[NSBundle mainBundle] pathForResource:@"staticbeam09v" ofType:@"caf"];	
	CFURLRef beamURL = (CFURLRef ) [NSURL fileURLWithPath:beamPath];
	AudioServicesCreateSystemSoundID (beamURL, &testbeam);
	
	//	AudioServicesPlaySystemSound(testbeam);
}

-(void)killplayer:(p*)wp wpi:(int)wpi{
	float spawnx;
	if (wpi == 0){
		spawnx = ((p*)[pry objectAtIndex:1]).l.x;	
	}else{
        spawnx = ((p*)[pry objectAtIndex:0]).l.x;	
	}
	
	if (fabsf(spawnx - 0) <= fabsf(spawnx - 768)){
		spawnx = 748;
	}else{
		spawnx = 20;
	}
	
	wp.l = CGPointMake(spawnx,wp.l.y);
	wp.mtar = CGPointMake(wp.l.x,0);
	if (wpi == 0){
		wp.mtar = CGPointMake(wp.l.x,1024);	
	}
}

-(void)damage:(int)wp :(bul*)wb{
	
	((p*)[pry objectAtIndex:wp]).hp--;
	
	if (wb.k == 2){
		((p*)[pry objectAtIndex:wp]).hp-=4;
	}
	
	int playing = -1;
	if (wb.k == 1){
		for (int i = soundIndexPlasmaHitStart; i <= soundIndexPlasmaHitMax; i++){
			
			if (playing == -1){
				if (((SoundFile *)[self.soundsarray objectAtIndex:i]).tick == 0){
					playing = i;
				}
			}
		}
	}
	
	if (wb.k == 2){
		for (int i = soundIndexRocketHitStart; i <= soundIndexRocketHitMax; i++){
			
			if (playing == -1){
				if (((SoundFile *)[self.soundsarray objectAtIndex:i]).tick == 0){
					playing = i;
				}
			}
		}
		
	}
	
	if (playing > -1){
		AudioServicesPlaySystemSound([((SoundFile*)[self.soundsarray objectAtIndex:playing]).soundID intValue]);
		((SoundFile*)[self.soundsarray objectAtIndex:playing]).tick = ((SoundFile*)[self.soundsarray objectAtIndex:playing]).tickreset;
	}
	
	
	//update score
	//update displays
	
	if ( ((p*)[pry objectAtIndex:wp]).hp <= 0){
		[self killplayer:((p*)[pry objectAtIndex:wp]) wpi:wp];
		((p*)[pry objectAtIndex:wp]).hp = hpreset;
		
		
		playing = -1;
		for (int i = soundIndexShipExplodeStart; i <= soundIndexShipExplodeMax; i++){
			
			if (playing == -1){
				if (((SoundFile *)[self.soundsarray objectAtIndex:i]).tick == 0){
					playing = i;
				}
			}
		}
		
		
		if (playing > -1){
			AudioServicesPlaySystemSound([((SoundFile*)[self.soundsarray objectAtIndex:playing]).soundID intValue]);
			((SoundFile*)[self.soundsarray objectAtIndex:playing]).tick = ((SoundFile*)[self.soundsarray objectAtIndex:playing]).tickreset;
		}	
		
		
		int winner = -1;
		
		if (wp == 0){
			p2kills++;	
			p1ships--;
			if (p1ships == 0){
				winner = 1;	
			}
		}else{
			p1kills++;
			p2ships--;
			if (p2ships == 0){
				winner = 0;	
			}
		}
		
		killlabel1.text = [NSString stringWithFormat:@"%d - Ships - %d",p1ships, p1ships];
		killlabel2.text = [NSString stringWithFormat:@"%d - Ships - %d",p2ships, p2ships];
		
		if (winner > -1){
			if (winner == 0){
				((p*)[pry objectAtIndex:1]).l = CGPointMake( ((p*)[pry objectAtIndex:1]).l.x,-100);	
				p11label.text = @"VICTORY";
				if (wb.k == 2){
					p22label.text = @"OBLITERATED";
				}else{
					p22label.text = @"INCINERATED";	
				}
				killlabel2.text = @"";
				p11label.textColor = [UIColor greenColor];
				p22label.textColor = [UIColor redColor];				
			}else{
				((p*)[pry objectAtIndex:0]).l = CGPointMake( ((p*)[pry objectAtIndex:0]).l.x,1124);				
				if (wb.k == 2){
                    p11label.text = @"OBLITERATED";
				}else{
                    p11label.text = @"INCINERATED";	
				}
				p22label.text = @"VICTORY";				
				killlabel1.text = @"";
				p22label.textColor = [UIColor greenColor];
				p11label.textColor = [UIColor redColor];
			}
			p11label.alpha = 1;
			p22label.alpha = 1;			
			gamestate = 4;
			gamestatetick = 7 * gameRate;
			
			self.exitButton.center = CGPointMake(384,512-120);
			self.exitButton.transform = CGAffineTransformMakeRotation(2*deg90);
			self.rematchButton.center = CGPointMake(384,512+120);
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	self.healthbar1.progress = ((p*)[pry objectAtIndex:0]).hp / hpreset;
	self.healthbar2.progress = ((p*)[pry objectAtIndex:1]).hp / hpreset;
	
	//	}
	
	if (wp == 0){
		p2hits++;
		//p1label.text = [NSString stringWithFormat:@"%d",p2hits];
	}
	
	if (wp == 1){
		p1hits++;
		//		p2label.text = [NSString stringWithFormat:@"%d",p1hits];
	}
	
}

-(void)getnb{
	nb = -1;
	for (int i = 0; i <= maxbullets; i++){
		if (nb == -1){
			if ( ((bul*)[bry objectAtIndex:i]).k == -1){
				nb = i;	
			}
		}
	}
}

-(void)shoot:(p*)wp :(bul*)wb :(int)side{
	wb.k = wp.weapon;
	wb.who = wp.k;
	wb.l = wp.l;
	wb.l = CGPointMake(wb.l.x, wb.l.y + (wb.vel.y * 3));	
	if (side == 1){
		wb.l = CGPointMake(wb.l.x+20, wb.l.y + (wb.vel.y * 3));			
	}
	if (side == -1){
		wb.l = CGPointMake(wb.l.x-20, wb.l.y + (wb.vel.y * 3));			
	}
}


-(void)shoot:(p*)wp :(bul*)wb {
	wb.k = wp.weapon;
	wb.who = wp.k;
	wb.l = wp.l;
	wb.l = CGPointMake(wb.l.x, wb.l.y + (wb.vel.y * 3));	
}

-(void)fireburst:(p*)wp{
	
	if (wp.weapon == 4){ //Spray pattern
		[self getnb];
		bul *wb = ((bul*)[bry objectAtIndex:nb]);
		if (nb > -1){
			wb.vel = CGPointMake(0,wp.wvspeed);
			[self shoot:wp  :wb];
		}
		
		[self getnb];
		wb = ((bul*)[bry objectAtIndex:nb]);
		if (nb > -1){
			wb.vel = CGPointMake(-.38,wp.wvspeed);
			[self shoot:wp :wb];
		}
		
		[self getnb];
		wb = ((bul*)[bry objectAtIndex:nb]);
		if (nb > -1){
			wb.vel = CGPointMake(.38,wp.wvspeed);
			[self shoot:wp :wb];
		}
		
	}
}



-(void)firebullet:(p*)wp :(bul*)wb{
	[self.bry addObject:wb];
	//	wp.weapon = 1;
    
	wb.radius = 45;
	
	wb.k = wp.weapon;
	wb.who = wp.k;
	
	int playing = -1;
	if (wb.k == 1){
		for (int i = soundIndexPlasmaStart; i <= soundIndexPlasmaMax; i++){
			
			if (playing == -1){
				if (((SoundFile *)[self.soundsarray objectAtIndex:i]).tick == 0){
					playing = i;
				}
			}
		}
	}
	
	if (wb.k == 2){
		for (int i = soundIndexRocketStart; i <= soundIndexRocketMax; i++){
			
			if (playing == -1){
				if (((SoundFile *)[self.soundsarray objectAtIndex:i]).tick == 0){
					playing = i;
				}
			}
		}
		
	}
	
	if (playing > -1){
		AudioServicesPlaySystemSound([((SoundFile*)[self.soundsarray objectAtIndex:playing]).soundID intValue]);
		((SoundFile*)[self.soundsarray objectAtIndex:playing]).tick = ((SoundFile*)[self.soundsarray objectAtIndex:playing]).tickreset;
	}
	
	
	
	
	if (wb.who == 0){
		if (wb.k == 1){
			((UIImageView*)[bdry objectAtIndex:wb.index]).transform = 
			CGAffineTransformConcat(CGAffineTransformMakeScale(1,1),CGAffineTransformMakeRotation(deg90));
		}else{
			((UIImageView*)[bdry objectAtIndex:wb.index]).transform = 
			CGAffineTransformConcat(CGAffineTransformMakeScale(2,2),CGAffineTransformMakeRotation(-deg90));					
		}
	}else{
		if (wb.k == 1){
			((UIImageView*)[bdry objectAtIndex:wb.index]).transform = 
			CGAffineTransformConcat(CGAffineTransformMakeScale(1,1),CGAffineTransformMakeRotation(-deg90));		
		}else{
			((UIImageView*)[bdry objectAtIndex:wb.index]).transform = 
			CGAffineTransformConcat(CGAffineTransformMakeScale(2,2),CGAffineTransformMakeRotation(deg90));	
		}
	}
	
	if (wp.weapon == 1){
		myint = random() % 5;
		
		
		if (myint == 0){
			wb.vel = CGPointMake(-.5,wp.wvspeed);
		}
		if (myint == 1){
			wb.vel = CGPointMake(.5,wp.wvspeed);			
		}
		if (myint == 2){
			wb.vel = CGPointMake(0,wp.wvspeed);
		}
		if (myint == 3){
			wb.vel = CGPointMake(-.7,wp.wvspeed);
		}
		if (myint == 4){
			wb.vel = CGPointMake(.7,wp.wvspeed);
		}
		
		
		
		
	
	}
	if (wp.weapon == 2){
		
		myint = random() % 1;
		
		if (myint == 0){
			myint -1;
		}
		
		randint = random() % weapon2wide;
		randint = randint * myint;
		randf = randint;
		wb.vel = CGPointMake(randf, wp.wvspeed);
		
	}
	
	if (wp.weapon == 4){
		
	}
	
	
	
	if (wb.k == 1){
		wb.animf = 0;
		wb.animfmax = 45;
		((UIImageView*)[bdry objectAtIndex:wb.index]).image = ((UIImageView *)[plasmaref objectAtIndex:wb.animf]).image;
	}else{
		wb.animf = 0;
		wb.animfmax = 28;
		((UIImageView*)[bdry objectAtIndex:wb.index]).image = ((UIImageView *)[rocketref objectAtIndex:wb.animf]).image;		
	}
	

	
	wb.l = wp.l;
	wb.l = CGPointMake(wb.l.x, wb.l.y + (wb.vel.y * 6));
	NSLog(@"wb.l.x/y: %f %f",wb.l.x, wb.l.y);
	NSLog(@"wb.vel.y: %f", wb.vel.y);
	NSLog(@"bullets count: %d",[self.bry count]);
}

-(void)playerloop:(p*)wp{
	
	//calculate vel by weapon towards mtar
	
	[self checkplayerstate];
	
	wp.thrustdelay--;
	if (wp.thrustdelay <= 0){
		wp.thrustdelay = wp.thrustdelayreset;	
		wp.cthrustanimf++;
		if (wp.cthrustanimf > wp.thrustmaxanimf){
			wp.cthrustanimf = 0;	
		}
		
	}
	
	
	wp.weapon = 0;
	
	wp.weapon = wp.pfire;
	
	if (wp.k == 0){
		
		if (wp.pfire == 1){
			wp.weapon = 1;
			wp.repeatreset = weapon1repeatreset;
		}
		if (wp.pfire == 2){
			wp.weapon = 2;
			wp.wvspeed = -weapon2speed;
			wp.repeatreset = weapon2repeatreset;
		}
		
	}
	
	
	if (wp.k == 1){
		
		if (wp.pfire == 1){
			wp.weapon = 1;
			wp.repeatreset = weapon1repeatreset;
		}
		if (wp.pfire == 2){
			wp.weapon = 2;
			wp.wvspeed = weapon2speed;
			wp.repeatreset = weapon2repeatreset;
		}
		
	}
	
	
	
	if (wp.weapon == 0){
		if (wp.freezetime <= 0){		
			wp.speed = speed0;
		}
		if (wp.freezetime > 0){
			wp.freezetime--;
		}
	}
	
	
	

	
	wp.vel = CGPointMake(0,0);
	
	if (wp.pdir == -1){
		wp.vel = CGPointMake(-wp.speed,0);
	}
	if (wp.pdir == -1){
		wp.vel = CGPointMake(-wp.speed,0);
	}
	
	wp.vel = CGPointMake(wp.speed * wp.pdir,0);
	
	
	wp.l = CGPointMake(wp.l.x+wp.vel.x,wp.l.y+wp.vel.y);
	
	if (wp.l.x < 20){
		wp.l = CGPointMake(20,wp.l.y+wp.vel.y);
	}
	if (wp.l.x > 748){
		wp.l = CGPointMake(748,wp.l.y+wp.vel.y);	
	}
	
	wp.pdir = 0;
	
	if (wp.mtar.y < 0){
		wp.vel = CGPointMake(0,0);
	}
	if (wp.mtar.y > 480){
		wp.vel = CGPointMake(0,0);
	}
	
	
	
	
	if (gamestate == 1){
		
		if (wp.repeat > 0) {
			wp.repeat--;
		}
		
		if (wp.weapon > 0){
            if (wp.repeat <= 0){
                wp.repeat = wp.repeatreset;
                if (wp.weapon == 1){
                    wp.freezetime = weapon1freeze;
                }
                if (wp.weapon == 2){
                    wp.freezetime = weapon1freeze;
                }
                [self getnb];
                if (nb > -1 ){
                    ((bul*)[bry objectAtIndex:nb]).index = nb;
                    
                    [self firebullet:(wp) :( ((bul*)[bry objectAtIndex:nb]) )];
                }
            }
        }
        
		
	}
	
	
	wp.pfire = 0;
	
}

-(void)bulletloop:(bul*)wb{
	
	wb.l = CGPointMake(wb.l.x+wb.vel.x,wb.l.y+wb.vel.y);
	
	wb.animf++;
	if (wb.animf > wb.animfmax){
		wb.animf = 0;
		if (wb.k > 5){
			wb.k = -1;
			wb.l = CGPointMake(5000,5000);
		}
	}
	
	if (wb.k == 1){
		((UIImageView*)[bdry objectAtIndex:wb.index]).image = ((UIImageView *)[plasmaref objectAtIndex:wb.animf]).image;
	}
	if (wb.k == 6){
		((UIImageView*)[bdry objectAtIndex:wb.index]).image = ((UIImageView *)[plasmadispersearray objectAtIndex:wb.animf]).image;
	}
	
	if (wb.k == 2){
		((UIImageView*)[bdry objectAtIndex:wb.index]).image = ((UIImageView *)[rocketref objectAtIndex:wb.animf]).image;
	}
	if (wb.k == 7){
		((UIImageView*)[bdry objectAtIndex:wb.index]).image = ((UIImageView *)[explosionrefarray objectAtIndex:wb.animf]).image;
	}
	for (int i = 0; i <= 1; i++){
		
		//90, 1024-85-35-30, 874
		if (wb.l.y < 105 || wb.l.y > 874-20){ 
			wb.k = -1;
			wb.l = CGPointMake(5000,5000);
		}
		
		if ( [GameMath GetDist:(wb.l) :( ((p*)[pry objectAtIndex:i]).l)] <= wb.radius){
			if ( wb.who != i){
				if (wb.k < 3){
					[self damage:(i) :(wb)];	
					wb.k += 5;
					
					wb.animf = 32;
					wb.animfmax = 59;
					if (wb.k == 7){
						wb.animf = 8;
						wb.animfmax = 23;	
					}
					
					if (wb.who == 0){
						if (wb.k == 7){
							((UIImageView*)[bdry objectAtIndex:wb.index]).transform = 
							CGAffineTransformConcat(CGAffineTransformMakeScale(1.5,1.5),CGAffineTransformMakeRotation(-deg90));					
						}
					}else{
						if (wb.k == 7){
							((UIImageView*)[bdry objectAtIndex:wb.index]).transform = 
							CGAffineTransformConcat(CGAffineTransformMakeScale(1.5,1.5),CGAffineTransformMakeRotation(deg90));		
						}
					}
				}
			}
		}
	}
	
}

-(void)soundsloop{
	
	for (SoundFile *sf in self.soundsarray){
		if (sf.tick > 0){
			sf.tick--;	
		}
	}
	
	
	
	
	
}

-(void)loop{
	
	if (gamestate == 2){
		gamestatetick--;
		if (gamestatetick == 0){
			p1label.alpha = 0;
            p11label.alpha = 0;
            p111label.alpha = 0;
            p2label.alpha = 0;
            p22label.alpha = 0;
            p222label.alpha = 0;
			[self readygame];	
			
		}
	}
	
	
    //	if (gamestate == 1 || gamestate == 3){
    
    //		if ( ((p*)[pry objectAtIndex:0]).l.y < weapon1dist){
    //			((p*)[pry objectAtIndex:0]).weapon = 0;
    //		}
    //		if ( ((p*)[pry objectAtIndex:0]).l.y < weapon1dist){
    //			((p*)[pry objectAtIndex:0]).weapon = 0;
    //		}
    //		if ( ((p*)[pry objectAtIndex:0]).l.y < weapon1dist){
    //			((p*)[pry objectAtIndex:0]).weapon = 0;
    //		}
    
    [self playerloop:((p*)[pry objectAtIndex:0])];
    ((UIImageView*)[pdry objectAtIndex:0]).center = ((p*)[pry objectAtIndex:0]).l;
    self.shipexhaust1.center = CGPointMake( ((p*)[pry objectAtIndex:0]).l.x, ((p*)[pry objectAtIndex:0]).l.y+40);
    self.shipexhaust1.image = ((UIImageView *)[thrustrefarray objectAtIndex:((p*)[pry objectAtIndex:0]).cthrustanimf]).image;
    
    self.shipexhaust1.transform = CGAffineTransformConcat(
                                                          
                                                          CGAffineTransformMakeScale(3, 3)
                                                          
                                                          , CGAffineTransformMakeRotation(-deg90));
    
    
    
    [self playerloop:((p*)[pry objectAtIndex:1])];		
    ((UIImageView*)[pdry objectAtIndex:1]).center = ((p*)[pry objectAtIndex:1]).l;		
    
    self.shipexhaust2.center = CGPointMake( ((p*)[pry objectAtIndex:1]).l.x, ((p*)[pry objectAtIndex:1]).l.y-40);
    self.shipexhaust2.image = ((UIImageView *)[thrustrefarray objectAtIndex:((p*)[pry objectAtIndex:1]).cthrustanimf+30]).image;
    
    self.shipexhaust2.transform = CGAffineTransformConcat(
                                                          
                                                          CGAffineTransformMakeScale(1.5, 1.5)
                                                          
                                                          , CGAffineTransformMakeRotation(deg90*3));
    
    
    
    for (int i = 0; i <= maxbullets; i++){
        if ( ((bul*)[bry objectAtIndex:i]).k > -1){
            [self bulletloop:((bul*)[bry objectAtIndex:i])];
        }
        ((UIImageView*)[bdry objectAtIndex:i]).center = ((bul*)[bry objectAtIndex:i]).l;
    }
    
    [self soundsloop];
    
    
    //	}
    
	if (gamestate == 3){
		[self countdown];	
	}
	
}

-(void)countdown{
	self.exitButton.center = CGPointMake(5000,5000);
	self.rematchButton.center = CGPointMake(5000,5000);	
	((UIImageView *)[pdry objectAtIndex:0]).image = ((UIImageView *)[shiprefarray objectAtIndex:0]).image;	
	((UIImageView *)[pdry objectAtIndex:1]).image = ((UIImageView *)[ship2refarray objectAtIndex:0]).image;		
	((UIImageView*)[pdry objectAtIndex:1]).transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-deg90), 
																			   CGAffineTransformMakeScale(2.3,2.3));
	
	gamestate = 2;
	killlabel1.text = [NSString stringWithFormat:@"GET READY"];
	killlabel2.text = [NSString stringWithFormat:@"GET READY"];	
	gamestatetick = 50 * 3;
}

-(void)readygame{
	gamestate = 1;
	killlabel1.text = [NSString stringWithFormat:@"%d - Ships - %d",p1ships, p1ships];
	killlabel2.text = [NSString stringWithFormat:@"%d - Ships - %d",p2ships, p2ships];
	
}

-(void)resetships{
	((p*)[pry objectAtIndex:0]).l = CGPointMake( ((p*)[pry objectAtIndex:0]).l.x,1024-60);
	((p*)[pry objectAtIndex:1]).l = CGPointMake( ((p*)[pry objectAtIndex:1]).l.x,60);
	((p*)[pry objectAtIndex:0]).mtar = CGPointMake( ((p*)[pry objectAtIndex:0]).l.x, 1024);
	((p*)[pry objectAtIndex:1]).mtar = CGPointMake( ((p*)[pry objectAtIndex:1]).l.x, 0);	
	p1ships = shipreset;
	p2ships = shipreset;
}

-(void)resethealths{
	((p*)[pry objectAtIndex:0]).hp = hpreset;
	((p*)[pry objectAtIndex:1]).hp = hpreset;	
}


-(void)preparestats{
	weapon1wide = 45;
	weapon2wide = 90;
	weapon1dist = 83;
	weapon2dist = 83+36;
	weapon1speed = 7; //5 //6
	weapon2speed = 23; //17 //7 /11
	weapon1repeatreset = 14;
	weapon2repeatreset = 30;
	weapon1freeze = 30;
	weapon2freeze = 30;
	minmove = 13;
	speed0 = 16; //12
	speed1 = 6; //4
	speed2 = 6; //4
	hpreset = 7;
	((p*)[pry objectAtIndex:0]).ty = 460;
	((p*)[pry objectAtIndex:1]).ty = 0;
	
	((p*)[pry objectAtIndex:0]).repeat = 0;
	((p*)[pry objectAtIndex:1]).repeat = 0;	
	((p*)[pry objectAtIndex:0]).k = 0;
	((p*)[pry objectAtIndex:1]).k = 1;
	((p*)[pry objectAtIndex:0]).weapon = 0;
	((p*)[pry objectAtIndex:1]).weapon = 0;	
	((p*)[pry objectAtIndex:0]).wvspeed = -10;
	((p*)[pry objectAtIndex:1]).wvspeed = 10;		
	((p*)[pry objectAtIndex:0]).mtar = CGPointMake(384,1024);
	((p*)[pry objectAtIndex:1]).mtar = CGPointMake(384,0);
	
	shipreset = 3;
	((p*)[pry objectAtIndex:0]).l = CGPointMake(384,864);
	((p*)[pry objectAtIndex:1]).l = CGPointMake(384,160);	
	[self resetships];
	
	((UIImageView*)[pdry objectAtIndex:0]).transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-deg90), 
																			   CGAffineTransformMakeScale(1.8,1.8));
	
	((UIImageView*)[pdry objectAtIndex:1]).transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-deg90), 
																			   CGAffineTransformMakeScale(1.8,1.8));	
	
	((p*)[pry objectAtIndex:1]).vel = CGPointMake(0,0);
	
	((p*)[pry objectAtIndex:0]).pdir = 0;
	((p*)[pry objectAtIndex:1]).pdir = 0;	
	
	buttondist = 100;
	
	
	((p*)[pry objectAtIndex:0]).pshootA = CGPointMake(500,950);
	((p*)[pry objectAtIndex:0]).pshootB = CGPointMake(670,950);
	((p*)[pry objectAtIndex:0]).pFlyL = CGPointMake(60,950);	
	((p*)[pry objectAtIndex:0]).pFlyR = CGPointMake(200,950);
	
	((p*)[pry objectAtIndex:1]).pFlyL = CGPointMake(560,60);
	((p*)[pry objectAtIndex:1]).pFlyR = CGPointMake(690,60);
	((p*)[pry objectAtIndex:1]).pshootA = CGPointMake(210,60);
	((p*)[pry objectAtIndex:1]).pshootB = CGPointMake(60,60);
	
	((p*)[pry objectAtIndex:0]).k = 0;
	((p*)[pry objectAtIndex:1]).k = 1;	
	
	
	((p*)[pry objectAtIndex:0]).cthrustanimf = 0;
	((p*)[pry objectAtIndex:0]).thrustmaxanimf = 29;
	((p*)[pry objectAtIndex:0]).thrustdelay = 0;
	((p*)[pry objectAtIndex:0]).thrustdelayreset = 4;	
	
	((p*)[pry objectAtIndex:1]).cthrustanimf = 0;
	((p*)[pry objectAtIndex:1]).thrustmaxanimf = 15;
	((p*)[pry objectAtIndex:1]).thrustdelay = 0;
	((p*)[pry objectAtIndex:1]).thrustdelayreset = 8;	
	
	[self resethealths];
	
}

-(UILabel *)makelabelat:(CGRect)rect{
	UILabel *makelabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x-rect.size.width/2,rect.origin.y-rect.size.height,rect.size.width,rect.size.height)];
	makelabel.backgroundColor = [UIColor clearColor];
	makelabel.textColor = [UIColor whiteColor];
	makelabel.font = [UIFont systemFontOfSize:30];
	makelabel.textAlignment = UITextAlignmentCenter;
	return [makelabel autorelease];
}

-(UIView *)makeZoneViewAtHeight:(float)Y withText:(NSString *)text andColor:(int)colorcode{
	//green, blue, red
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,Y,768,35)];	
	if (colorcode == 0){
		view.backgroundColor = [UIColor greenColor];	
	}
	if (colorcode == 1){
		view.backgroundColor = [UIColor blueColor];		
	}
	if (colorcode == 2){
		view.backgroundColor = [UIColor redColor];	
	}
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100,35)];
	label.backgroundColor = [UIColor clearColor];
	if (colorcode == 0){
		label.textColor = [UIColor blackColor];
	}
	if (colorcode == 1){
		label.textColor = [UIColor whiteColor];
	}
	if (colorcode == 2){
		label.textColor = [UIColor blackColor];
	}
	label.text = text;
	[view addSubview:label];
	
	[label release];
	
	
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(710, 0, 100,35)];
	label2.backgroundColor = [UIColor clearColor];
	if (colorcode == 0){
		label2.textColor = [UIColor blackColor];
	}
	if (colorcode == 1){
		label2.textColor = [UIColor whiteColor];
	}
	if (colorcode == 2){
		label2.textColor = [UIColor blackColor];
	}
	label2.text = text;
	[view addSubview:label2];
	[label2 release];
	
	return view;
	
}

// Implement viewto do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {	
    //	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	srandom(time(NULL));
	p1hits = 0;
	p2hits = 0;
	
	gameRate = 50;
	
	maxbullets = 60;
	
	
	
	int fontSize = 33;
	int specialHeight = 20;
	int bottomHeight = 45;
	p1label = [[UILabel alloc] initWithFrame:CGRectMake(384-300,1024-400+specialHeight,600,50)];
	p1label.backgroundColor = [UIColor clearColor];
	p1label.font = [UIFont systemFontOfSize:fontSize];
	p1label.textColor = [UIColor whiteColor];
	p1label.textAlignment = UITextAlignmentCenter;
	p11label = [[UILabel alloc] initWithFrame:CGRectMake(384-400,1024-350+specialHeight,800,50)];
	p11label.backgroundColor = [UIColor clearColor];
	p11label.font = [UIFont systemFontOfSize:fontSize];
	p11label.textColor = [UIColor whiteColor];
	p11label.textAlignment = UITextAlignmentCenter;
	p111label = [[UILabel alloc] initWithFrame:CGRectMake(384-300,1024-300+specialHeight,600,50)];
	p111label.backgroundColor = [UIColor clearColor];
	p111label.font = [UIFont systemFontOfSize:fontSize];
	p111label.textColor = [UIColor whiteColor];
	p111label.textAlignment = UITextAlignmentCenter;
    
	
	p2label = [[UILabel alloc] initWithFrame:CGRectMake(384-300,400-100+specialHeight,600,50)];
	p2label.backgroundColor = [UIColor clearColor];
	p2label.font = [UIFont systemFontOfSize:fontSize];
	p2label.textColor = [UIColor whiteColor];
	p2label.textAlignment = UITextAlignmentCenter;
	p22label = [[UILabel alloc] initWithFrame:CGRectMake(384-400,350-100+specialHeight,800,50)];
	p22label.backgroundColor = [UIColor clearColor];
	p22label.font = [UIFont systemFontOfSize:fontSize];
	p22label.textColor = [UIColor whiteColor];
	p22label.textAlignment = UITextAlignmentCenter;
	p222label = [[UILabel alloc] initWithFrame:CGRectMake(384-300,300-100+specialHeight,600,50)];
	p222label.backgroundColor = [UIColor clearColor];
	p222label.font = [UIFont systemFontOfSize:fontSize];
	p222label.textColor = [UIColor whiteColor];
	p222label.textAlignment = UITextAlignmentCenter;
    
	[self setIntroText];
	
    deg90 = 1.570796326794897;
	
	p2label.transform = CGAffineTransformMakeRotation(deg90 * 2);
	p22label.transform = CGAffineTransformMakeRotation(deg90 * 2);
	p222label.transform = CGAffineTransformMakeRotation(deg90 * 2);
	
	[self.view addSubview:p11label];
	[self.view addSubview:p111label];
	[self.view addSubview:p22label];
	[self.view addSubview:p222label];
    
	
 	
	
	
	self.healthbar1 = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	self.healthbar1.frame = CGRectMake(0,0,200,30);
	self.healthbar1.center = CGPointMake(745+23+0,512-30);
	self.healthbar1.transform = CGAffineTransformMakeRotation(-deg90);
	self.healthbar1.center = CGPointMake(self.healthbar1.center.x, self.healthbar1.center.y+specialHeight);
	self.healthbar1.progress = 1;
	//[self.view addSubview:self.healthbar1];
	
	self.healthbar2 = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	self.healthbar2.frame = CGRectMake(0,0,200,30);
	self.healthbar2.center = CGPointMake(0,512-30+specialHeight);
	self.healthbar2.transform = CGAffineTransformMakeRotation(deg90);
	self.healthbar2.progress = 1;
//	[self.view addSubview:self.healthbar2];
	
	killlabel1 = [self makelabelat:CGRectMake(715,512+specialHeight,220,60)];
	killlabel1.transform = CGAffineTransformMakeRotation(deg90);
	[self.view addSubview:killlabel1];
	killlabel1.text = @"0 - Ships - 0";
	
	
	killlabel2 = [self makelabelat:CGRectMake(53,512+specialHeight,220,60)];
	killlabel2.transform = CGAffineTransformMakeRotation(deg90 * 3);
	[self.view addSubview:killlabel2];
	killlabel2.text = @"0 - Ships - 0";
	
	killlabel1.text = [NSString stringWithFormat:@"%d - Ships - %d",p1ships, p1ships];
	killlabel2.text = [NSString stringWithFormat:@"%d - Ships - %d",p2ships, p2ships];
	
	
	[self.view addSubview:p1label];
	[self.view addSubview:p2label];	
	
	[self initializearrays];
	[self initializesounds];
	
	[self preparestats];
    //	[self readygame];
	
//	UIButton *
	
	gamestate = 3;
	myTimer = [[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(loop) userInfo:nil repeats:YES] retain];	
    [super viewDidLoad];
}

- (void)dealloc {
    [super dealloc];
}

-(UIImage*)getship2image{
	
	if ( ((p*)[pry objectAtIndex:1]).pdir == -1){
		return ((UIImageView *)[ship2refarray objectAtIndex:((p*)[pry objectAtIndex:1]).canimf]).image;
	}else{
		return ((UIImageView *)[ship2refarray objectAtIndex:((p*)[pry objectAtIndex:1]).canimf+30]).image;	
	}
	
	return nil;
}


-(UIImage*)getshipimage{
	
	if ( ((p*)[pry objectAtIndex:0]).pdir == -1){
		return ((UIImageView *)[shiprefarray objectAtIndex:((p*)[pry objectAtIndex:0]).canimf]).image;
	}else{
		return ((UIImageView *)[shiprefarray objectAtIndex:((p*)[pry objectAtIndex:0]).canimf+30]).image;	
	}
	
	return nil;
}

-(void)checkplayerstate{
	
	//	((p*)[pry objectAtIndex:0]).pdir = 0;
	((p*)[pry objectAtIndex:0]).maxanimf = 30;
	
	if ( ((p*)[pry objectAtIndex:0]).mtar.x > ((p*)[pry objectAtIndex:0]).l.x + minmove ){
		((p*)[pry objectAtIndex:0]).pdir = 1;	
	}
	if ( ((p*)[pry objectAtIndex:0]).mtar.x < ((p*)[pry objectAtIndex:0]).l.x - minmove){
		((p*)[pry objectAtIndex:0]).pdir = -1;	
	}
	
	((p*)[pry objectAtIndex:1]).pdir = 0;
	((p*)[pry objectAtIndex:1]).pfire = 0;
	
	if ( ((p*)[pry objectAtIndex:1]).mtar.x > ((p*)[pry objectAtIndex:1]).l.x + minmove){
		((p*)[pry objectAtIndex:1]).pdir = 1;			
	}
	if ( ((p*)[pry objectAtIndex:1]).mtar.x < ((p*)[pry objectAtIndex:1]).l.x - minmove){
		((p*)[pry objectAtIndex:1]).pdir = -1;	
	}
	
		
	if ( ((p*)[pry objectAtIndex:0]).canimf < ((p*)[pry objectAtIndex:0]).maxanimf){
		((p*)[pry objectAtIndex:0]).canimf++;
	}
	
	if ( ((p*)[pry objectAtIndex:0]).pdir == 0){
		if ( ((p*)[pry objectAtIndex:0]).canimf > 0){
			((p*)[pry objectAtIndex:0]).canimf = 0;	
			((UIImageView *)[pdry objectAtIndex:0]).image = ((UIImageView *)[shiprefarray objectAtIndex:0]).image;	
			((UIImageView*)[pdry objectAtIndex:0]).transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-deg90), 
																					   CGAffineTransformMakeScale(2.3,2.3));
			
		}
	}
	
	if ( ((p*)[pry objectAtIndex:0]).canimf > 0 && ((p*)[pry objectAtIndex:0]).pdir != 0){
		((UIImageView *)[pdry objectAtIndex:0]).image = [self getshipimage];
		((UIImageView*)[pdry objectAtIndex:0]).transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-deg90), 
																				   CGAffineTransformMakeScale(2.3,2.3));
	}
	
	
	
	
	if ( ((p*)[pry objectAtIndex:1]).canimf < ((p*)[pry objectAtIndex:1]).maxanimf){
		((p*)[pry objectAtIndex:1]).canimf++;
	}
	
	if ( ((p*)[pry objectAtIndex:1]).pdir == 0){
		if ( ((p*)[pry objectAtIndex:1]).canimf > 0){
			((p*)[pry objectAtIndex:1]).canimf = 0;	
			((UIImageView *)[pdry objectAtIndex:1]).image = ((UIImageView *)[ship2refarray objectAtIndex:1]).image;	
			((UIImageView*)[pdry objectAtIndex:1]).transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(-deg90), 
																					   CGAffineTransformMakeScale(2.3,2.3));
			
		}
	}
	
	if ( ((p*)[pry objectAtIndex:1]).canimf > 0 && ((p*)[pry objectAtIndex:1]).pdir != 0){
		((UIImageView *)[pdry objectAtIndex:1]).image = [self getship2image];
		((UIImageView*)[pdry objectAtIndex:1]).transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(3*deg90), 
																				   CGAffineTransformMakeScale(2.3,2.3));
		
	}
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	gestureStartPoint = [touch locationInView:self.view];
	
	if (gestureStartPoint.y < 150){ //512
		((p*)[pry objectAtIndex:1]).mtar = gestureStartPoint;        
	}else if (gestureStartPoint.y > 860){
		((p*)[pry objectAtIndex:0]).mtar = gestureStartPoint;
	}    
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	currentPosition = [touch locationInView:self.view];
	
	
	
	if (currentPosition.y < 115){ //512
		((p*)[pry objectAtIndex:1]).mtar = currentPosition;
		//	if (gestureStartPoint.x > 384){
		//		((p*)[pry objectAtIndex:1]).pmovpoint = currentPosition;
		//	}else{
		//		
		//		((p*)[pry objectAtIndex:1]).pfirepoint = currentPosition;
		//	}
	}else if (currentPosition.y > 860){
		((p*)[pry objectAtIndex:0]).mtar = currentPosition;		
		//	if (gestureStartPoint.x < 384){
		//		
		//		((p*)[pry objectAtIndex:0]).pmovpoint = currentPosition;
		//	}else{
		//		
		//		((p*)[pry objectAtIndex:0]).pfirepoint = currentPosition;
		//	}	
	}	
	
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	
	UITouch *touch = [touches anyObject];
	currentPosition = [touch locationInView:self.view];
	
	
	if (currentPosition.y < 512){
		((UIImageView *)[pdry objectAtIndex:1]).image = ((UIImageView *)[ship2refarray objectAtIndex:0]).image;		
		
		((p*)[pry objectAtIndex:1]).pdir = 0;
		((p*)[pry objectAtIndex:1]).pfire = 0;
		//		((p*)[pry objectAtIndex:1]).mtar = CGPointMake( ((p*)[pry objectAtIndex:1]).l.x, 0);
		
		if (currentPosition.x > 384){
			((p*)[pry objectAtIndex:1]).mdown = 0;
		}else{
			((p*)[pry objectAtIndex:1]).fdown = 0;
			((p*)[pry objectAtIndex:1]).weapon = 0;
		}
		
		((p*)[pry objectAtIndex:1]).mtar = CGPointMake( ((p*)[pry objectAtIndex:1]).l.x, 0);
		
	}else{
		
		((UIImageView *)[pdry objectAtIndex:0]).image = ((UIImageView *)[shiprefarray objectAtIndex:0]).image;
		
		((p*)[pry objectAtIndex:0]).pdir = 0;
		((p*)[pry objectAtIndex:0]).weapon = 0;
		//		((p*)[pry objectAtIndex:0]).mtar = CGPointMake( ((p*)[pry objectAtIndex:0]).l.x, 1024);
		
		if (currentPosition.x < 384){
			((p*)[pry objectAtIndex:0]).mdown = 0;
		}else{
			((p*)[pry objectAtIndex:0]).fdown = 0;
			((p*)[pry objectAtIndex:0]).weapon = 0;			
		}	
		
		((p*)[pry objectAtIndex:0]).mtar = CGPointMake( ((p*)[pry objectAtIndex:0]).l.x, 1024);
		
	}
}

-(IBAction)firePlasma0 {
	((p *)[pry objectAtIndex:0]).pfire = 1;	
}

@end
