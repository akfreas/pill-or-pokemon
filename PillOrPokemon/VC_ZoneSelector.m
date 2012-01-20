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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
