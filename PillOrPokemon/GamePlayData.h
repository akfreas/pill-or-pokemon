@class QuizItem;
@interface GamePlayData : NSObject

-(id)initWithZone:(NSInteger)zone;
-(QuizItem *)quizItemAtIndex:(NSInteger)index;
-(NSInteger)count;
-(void)save;

@end
