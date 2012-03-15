#import "VC_ZoneSelector.h"
#import "Zone.h"


@implementation VC_ZoneSelector



-(id)init {
    self = [super initWithNibName:@"ZoneSelector" bundle:[NSBundle mainBundle]];
    return self;
}

-(void)refresh {
    [self configureZoneViews];
}

-(void)loadZone:(NSInteger)zone {
    
    VC_GamePlay *gameView = [[VC_GamePlay alloc] initWithZone:zone zoneSelector:self];
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

-(void)placeCompletedLabelInZone:(NSInteger)theZone {

    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:theZone];
    NSLog(@"Imageview frame: %f, %f", imageView.center.x, imageView.center.y);
    UILabel *completed = [[UILabel alloc] initWithFrame:CGRectMake(imageView.center.x - 160/2, imageView.center.y - 40/2, 160, 40)];
    
    completed.text = @"Completed";
    completed.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:20.0];
    completed.textAlignment = UITextAlignmentCenter;
    completed.layer.cornerRadius = 5;
    completed.transform = CGAffineTransformMakeRotation(M_PI - (M_PI / 8) * 6);
    completed.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:0 alpha:0.5];    
    [self.view addSubview:completed];
}

-(void)configureZoneViews {

    NSArray *zones = [[GamePlayData sharedInstance] zones];
    
    if(zones != nil) {
        
        for(Zone *zone in zones) {
            
            UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[zone.gameZone intValue]];
            
            if ([zone.unlocked isEqualToNumber:[NSNumber numberWithBool:YES]]) {                
                imageView.alpha = 1;
                imageView.userInteractionEnabled = YES;
                [self placeCompletedLabelInZone:[zone.gameZone intValue]];
                
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
    
    [self configureZoneViews];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
