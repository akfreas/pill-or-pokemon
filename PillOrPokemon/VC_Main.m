//
//  VC_Main.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VC_Main.h"
#import "VC_ZoneSelector.h"


@implementation VC_Main


-(id)init {
    self = [self initWithNibName:@"MainView" bundle:nil];
    return self;
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    firstTime = YES;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(firstTime){
        firstTime = NO;
        VC_SplashScreen *splashView = [[VC_SplashScreen alloc] init];
        UINavigationController *splashScreen = [[UINavigationController alloc] initWithRootViewController:splashView];
        splashScreen.modalPresentationStyle = UIModalPresentationFullScreen;
        splashScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:splashScreen animated:YES];
    } else {
        
        VC_ZoneSelector *zoneSelector = [[VC_ZoneSelector alloc] init];
        
        [self.view addSubview:zoneSelector.view];
        
    }
    

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
