    //
//  VC_GamePlay.m
//  PillOrPokemon
//
//  Created by Alexander Freas on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VC_GamePlay.h"
#import "GamePlayData.h"
#import "QuizItem.h"

@implementation VC_GamePlay {
    
    IBOutlet UILabel *quizItemLabel;
    IBOutlet UILabel *answerTextLabel;
    IBOutlet UILabel *answerDescriptionLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *progressLabel;
    
    IBOutlet UIButton *moveToNextButton;
    IBOutlet UIButton *pillButton;
    IBOutlet UIButton *pokeButton;
    
    IBOutlet UIProgressView *quizProgressView;
    
    NSInteger currentQuizItemIndex;
    NSUInteger score;
    NSUInteger zone;
    NSUInteger totalNumberOfQuestions;
    
    GamePlayData *quizData;
    NSMutableArray *incorrectQuizQuestions;
    NSArray *selectionType;
    QuizItem *currentQuizItem;
}

-(id)initWithZone:(NSInteger)theZone {
    self = [super initWithNibName:@"GamePlay" bundle:nil];
    zone = theZone;
    quizProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];

    incorrectQuizQuestions = [NSMutableArray arrayWithCapacity:0];
    quizData = [[GamePlayData alloc] initWithZone:theZone];
    totalNumberOfQuestions = [quizData count];
    return self;
}





-(NSString *)scoreString:(NSInteger)theScore totalPoints:(NSInteger)thePoints {
    
    NSString *progress = [NSString stringWithFormat:@"%d/%d", theScore, thePoints];
    return progress;
    
}

-(void)markCorrect {
    score++;
    quizItemLabel.textColor = [UIColor greenColor];
    answerTextLabel.textColor = [UIColor greenColor];
    answerTextLabel.text = @"Correct!";
    answerDescriptionLabel.text = currentQuizItem.itemDescription;
    currentQuizItem.correct = [NSNumber numberWithBool:YES];
    [quizData save];
    scoreLabel.text = [self scoreString:score totalPoints:totalNumberOfQuestions];
}

-(void)markIncorrect {
    quizItemLabel.textColor = [UIColor redColor];
    answerTextLabel.textColor = [UIColor redColor];
    answerTextLabel.text = @"Incorrect.";
    answerDescriptionLabel.text = currentQuizItem.itemDescription;
    currentQuizItem.correct = [NSNumber numberWithBool:NO];
    [quizData save];
}

-(void)moveToNextItem {
    
    if([quizData count] > 0) {
        currentQuizItemIndex++;
        float progress = (float)currentQuizItemIndex/(float)totalNumberOfQuestions;
        [quizProgressView setProgress:progress];
        
        
        NSInteger questionsRemaining = totalNumberOfQuestions - currentQuizItemIndex;
        
        progressLabel.text = [NSString stringWithFormat:@"%d questions left", questionsRemaining];

        
        currentQuizItem = [quizData quizItemAtIndex:currentQuizItemIndex];
        
        [self configureUIElementsForUnansweredQuestion];
        
        [moveToNextButton setTitle:@"Skip" forState:UIControlStateNormal]; 
        
    } else {
        
        BOOL perfect = NO;
        
        if (totalNumberOfQuestions == score) {
            perfect = YES;
        }
        [self showEndOfGameMessageWithStatus:perfect];
    }
    
}

-(void)showEndOfGameMessageWithStatus:(BOOL)perfect {

    NSString *endOfGameMessage;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Results"
                                                    message: @""
                                                   delegate: self
                                          cancelButtonTitle: @"Main Menu"
                                          otherButtonTitles: nil];
    if (perfect) {
        endOfGameMessage = [[NSString alloc] initWithString: @"Congratulations! You got a perfect score and have unlocked the next zone!"];
        [alert addButtonWithTitle:@"Proceed to next zone"];
    } else {
        endOfGameMessage = [[NSString alloc] initWithFormat: @"Your score was %d out of %d. Play again to get a perfect score and unlock the next level!", score, totalNumberOfQuestions];
        [alert addButtonWithTitle:@"Play again"];
    }
    
    alert.message = endOfGameMessage;
    
    [alert show];
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
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [quizData exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

-(void)setQuizData {
    
    NSString *gameInfoFile = [[NSBundle mainBundle] pathForResource:@"PPData" ofType:@"plist"];
    NSDictionary *temp = [[NSDictionary alloc] initWithContentsOfFile:gameInfoFile];
    selectionType = [[NSArray alloc] initWithObjects:@"pill", @"pokemon", nil];
    quizData = [NSMutableArray arrayWithArray:[[temp objectForKey:@"Root"] objectAtIndex:zone - 1]];
    totalNumberOfQuestions = [quizData count];

    [self shuffleQuizData];
}

-(void)configureUIElementsForUnansweredQuestion {
    
    quizItemLabel.text = [currentQuizItem valueForKey:@"name"];
    quizItemLabel.textColor = [UIColor whiteColor];
    
    answerTextLabel.hidden = YES;
    answerTextLabel.textColor = [UIColor whiteColor];
    
    answerDescriptionLabel.textColor = [UIColor whiteColor];
    answerDescriptionLabel.hidden = YES;
    
    pillButton.hidden = NO;
    pokeButton.hidden = NO;
    
    scoreLabel.text = [self scoreString:score totalPoints:totalNumberOfQuestions];
}

-(void)resetGame {
    
    [self setQuizData];
    [self configureUIElementsForUnansweredQuestion];
    
    currentQuizItemIndex = 0;
    score = 0;
  
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
