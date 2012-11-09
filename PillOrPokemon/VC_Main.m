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

@synthesize zoneSelector;


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

        splashView.modalPresentationStyle = UIModalPresentationFullScreen;
        splashView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:splashView animated:YES];
    } else {
        zoneSelector = [[VC_ZoneSelector alloc] init];
        
        [self.view addSubview:zoneSelector.view];
        
    }
    

}

@end
