//
//  VC_ZoneSelector.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VC_ZoneSelector.h"

@implementation VC_ZoneSelector


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

-(NSURL *)documentsUrl {
    
    NSURL *unlockedZonesPlistUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    unlockedZonesPlistUrl = [unlockedZonesPlistUrl URLByAppendingPathComponent:@"Scores.plist"];
    return unlockedZonesPlistUrl;
}

-(NSMutableArray *)unlockedZonesFromPlist {

    NSURL *unlockedZonesPlistUrl = [self documentsUrl];
    NSMutableArray *zones = [[NSDictionary dictionaryWithContentsOfURL:unlockedZonesPlistUrl] objectForKey:@"array"];
    return zones;
}

-(void)unlockZoneInPlist:(NSNumber *)zone {
    
    NSURL *unlockedZonesPlistUrl = [self documentsUrl];
    NSMutableArray *zones = [[NSDictionary dictionaryWithContentsOfURL:unlockedZonesPlistUrl] objectForKey:@"array"];
    [zones replaceObjectAtIndex:[zone intValue] withObject:@"unlocked"];
}

-(void)configureZoneViewsWithPlist {

    NSString *pathToScorePlist = [[NSBundle mainBundle] pathForResource:@"UnlockedZones" ofType:@"plist"];
    NSArray *scoreArray = [[NSDictionary dictionaryWithContentsOfFile:pathToScorePlist] objectForKey:@"Zones"];
    
    
    if(scoreArray != nil) {
        
        for(int i=0; i<[scoreArray count]; i++) {
            
            UIImageView *imageView = (UIImageView *)[self.view viewWithTag:i + 1];
            imageView.alpha = [[scoreArray objectAtIndex:i] floatValue]; // == YES ? 1 : 0;
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
