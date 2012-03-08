//
//  VC_ZoneSelector.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VC_ZoneSelector.h"

@implementation VC_ZoneSelector


+(NSURL *)documentsUrl {
    
    NSURL *unlockedZonesPlistUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    unlockedZonesPlistUrl = [unlockedZonesPlistUrl URLByAppendingPathComponent:@"Scores.plist"];
    return unlockedZonesPlistUrl;
}

+(NSMutableArray *)zonesFromPlist {
    
    NSURL *unlockedZonesPlistUrl = [VC_ZoneSelector documentsUrl];
    NSMutableArray *zones = [[NSDictionary dictionaryWithContentsOfURL:unlockedZonesPlistUrl] objectForKey:@"zones"];
    return zones;
}

+(void)unlockZoneInPlist:(NSNumber *)zone {
    
    NSMutableArray *zones = [VC_ZoneSelector zonesFromPlist];
    [zones replaceObjectAtIndex:[zone intValue] withObject:@"unlocked"];
    [VC_ZoneSelector saveZones:zones];
}

+(void)initializeZonePlistWithLockedZones {
    
    NSMutableArray *zones = [NSMutableArray arrayWithCapacity:4];
    [zones addObject:@"unlocked"];
    for (int i=1; i<4; i++) {
        [zones addObject:@"locked"];
    }
    
    [VC_ZoneSelector saveZones:zones];
}

+(void)initializeZonePlistWithUnlockedZones {
    
    NSMutableArray *zones =  [NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<4; i++) {
        [zones addObject:@"unlocked"];
    }

    [VC_ZoneSelector saveZones:zones];
}

+(void)saveZones:(NSMutableArray *)zones {
    
    NSURL *plistUrl = [self documentsUrl];
    NSDictionary *zoneDict = [NSDictionary dictionaryWithObject:zones forKey:@"zones"];
    [zoneDict writeToURL:plistUrl atomically:YES];
}

-(id)init {
    self = [super initWithNibName:@"ZoneSelector" bundle:[NSBundle mainBundle]];
    return self;
}

-(void)loadZone:(NSInteger)zone {
    
    VC_GamePlay *gameView = [[VC_GamePlay alloc] initWithZone:zone];
    UINavigationController *game = [[UINavigationController alloc] initWithRootViewController:gameView];
    game.navigationBar.tintColor = [UIColor blackColor];
    game.modalPresentationStyle = UIModalPresentationPageSheet;
    game.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:game animated:NO];
    
}

-(IBAction)zoneSelected:(id)sender  {
    
    UIButton *zoneButton = (UIButton *)sender;
    [self loadZone:zoneButton.tag];

}



-(void)configureZoneViewsWithPlist {

    NSArray *zones = [NSArray arrayWithArray:[VC_ZoneSelector zonesFromPlist]];
    
    if(zones != nil) {
        
        for(int i=0; i<[zones count]; i++) {
            UIImageView *imageView = (UIImageView *)[self.view viewWithTag:i + 1];
            
            if ([[zones objectAtIndex:i] isEqualToString:@"unlocked"]) {                
                imageView.alpha = 1;
                imageView.userInteractionEnabled = YES;
                
            } else {
                imageView.alpha = .25;
                imageView.userInteractionEnabled = NO;
                
            }
        }
    }
}

-(IBAction)showHelp:(id)sender {
    
    UIAlertView *helpAlert = [[UIAlertView alloc] initWithTitle:@"How to Play"
                                                        message:@"It's simple. Just select a zone and try to determine whether or not the displayed item is a pill or a Pokemon.  When you are ready to answer, click the 'Pill' or the 'Pokemon' button!" 
                                                       delegate:self
                                              cancelButtonTitle:@"Thanks!" 
                                              otherButtonTitles:nil];
    [helpAlert show];
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureZoneViewsWithPlist];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
