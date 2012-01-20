    //
//  VC_GamePlay.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VC_GamePlay.h"

@interface VC_GamePlay () {
    
    IBOutlet UILabel *quizItemLabel;
    IBOutlet UILabel *answerTextLabel;
    IBOutlet UILabel *answerDescriptionLabel;
    
    IBOutlet UIButton *moveToNextButton;
    IBOutlet UIButton *pillButton;
    IBOutlet UIButton *pokeButton;
    
    IBOutlet UIProgressView *quizProgressView;
    
    NSInteger currentQuizItemIndex;
    NSUInteger score;
    NSUInteger zone;
    NSUInteger totalNumberOfQuestions;
    
    NSMutableArray *quizData;
    NSArray *selectionType;
    NSDictionary *currentQuizItem;


}
-(void)resetGame;
@end

@implementation VC_GamePlay

-(id)initWithZone:(NSInteger)theZone {
    self = [super initWithNibName:@"GamePlay" bundle:nil];
    zone = theZone;
    return self;
    quizProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
}


-(void)markCorrect {
    score++;
    quizItemLabel.textColor = [UIColor greenColor];
    answerTextLabel.textColor = [UIColor greenColor];
    answerTextLabel.text = @"Correct!";
    answerDescriptionLabel.text = [currentQuizItem valueForKey:@"description"];
}

-(void)markIncorrect {
    quizItemLabel.textColor = [UIColor redColor];
    answerTextLabel.textColor = [UIColor redColor];
    answerTextLabel.text = @"Incorrect.";
    answerDescriptionLabel.text = [currentQuizItem valueForKey:@"description"];
}

-(void)moveToNextItem {
    
    if([quizData count] > 0) {
        currentQuizItemIndex++;
        float progress = (float)currentQuizItemIndex/(float)totalNumberOfQuestions;
        [quizProgressView setProgress:progress];
        currentQuizItem = [quizData objectAtIndex:0];
        [quizData removeObjectAtIndex:0];
        
        quizItemLabel.text = [currentQuizItem valueForKey:@"name"];
        quizItemLabel.textColor = [UIColor whiteColor];
        answerTextLabel.hidden = YES;
        answerTextLabel.textColor = [UIColor whiteColor];
        answerDescriptionLabel.textColor = [UIColor whiteColor];
        answerDescriptionLabel.hidden = YES;
        pillButton.hidden = NO;
        pokeButton.hidden = NO;
        
        [moveToNextButton setTitle:@"Skip" forState:UIControlStateNormal]; 
        
    } else {
        
        NSString *endOfGameData = [[NSString alloc] initWithFormat: @"Your score was %d out of %d.", score, totalNumberOfQuestions];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Results"
                                                        message: endOfGameData
                                                       delegate: self
                                              cancelButtonTitle: @"Sweet!"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void)shuffleQuizData {
    
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [quizData count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [quizData exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(void)resetGame {
    
    currentQuizItemIndex = 0;
    score = 0;
    NSString *gameInfoFile = [[NSBundle mainBundle] pathForResource:@"PPData" ofType:@"plist"];
    NSDictionary *temp = [[NSDictionary alloc] initWithContentsOfFile:gameInfoFile];
    selectionType = [[NSArray alloc] initWithObjects:@"pill", @"pokemon", nil];
    quizData = [NSMutableArray arrayWithArray:[[temp objectForKey:@"Root"] objectAtIndex:zone - 1]];
    [self shuffleQuizData];
    totalNumberOfQuestions = [quizData count];
    quizItemLabel.text = [currentQuizItem valueForKey:@"name"];
    quizItemLabel.textColor = [UIColor whiteColor];
    answerTextLabel.hidden = YES;
    answerTextLabel.textColor = [UIColor whiteColor];
    answerDescriptionLabel.textColor = [UIColor whiteColor];
    answerDescriptionLabel.hidden = YES;
    pillButton.hidden = NO;
    pokeButton.hidden = NO;
    
    [moveToNextButton setTitle:@"Skip" forState:UIControlStateNormal];   
    [self moveToNextItem];
}


-(void)goToHomeScreen {
    
    [self dismissModalViewControllerAnimated:YES];    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self goToHomeScreen];
    
}
-(IBAction)clickNext:(id)sender {
    
    [self moveToNextItem];
    
}

-(IBAction)chooseType:(id)sender {
    
    [moveToNextButton setTitle:@"Next" forState:UIControlStateNormal];   
    UIButton *selectedButton = (UIButton *)sender;
    answerTextLabel.hidden = NO;
    answerDescriptionLabel.hidden = NO;
    NSInteger selection = selectedButton.tag;
    
    if([[currentQuizItem objectForKey:@"type"] isEqualToString:[selectionType objectAtIndex:selection]]) {
        
        [self markCorrect];
        
    } else {
        [self markIncorrect];
    } 
    pillButton.hidden = YES;
    pokeButton.hidden = YES;
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleDone target:self action:@selector(goToHomeScreen)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStyleDone target:self action:@selector(resetGame)];
    
    [self resetGame];
}

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