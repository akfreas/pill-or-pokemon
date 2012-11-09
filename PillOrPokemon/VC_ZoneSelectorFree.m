#import "VC_ZoneSelectorFree.h"

@implementation VC_ZoneSelector


-(id)init {
    self = [super initWithNibName:@"ZoneSelectorFree" bundle:[NSBundle mainBundle]];
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

-(IBAction)showHelp:(id)sender {
    
    UIAlertView *helpAlert = [[UIAlertView alloc] initWithTitle:@"How to Play"
                                                        message:@"It's simple. Just select a zone and try to determine whether or not the displayed item is a pill or a Pokemon.  When you are ready to answer, click the 'Pill' or the 'Pokemon' button!" 
                                                       delegate:self
                                              cancelButtonTitle:@"Thanks!" 
                                              otherButtonTitles:nil];
    [helpAlert show];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
