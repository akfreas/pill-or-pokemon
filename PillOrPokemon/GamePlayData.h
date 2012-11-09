@class QuizItem;
@interface GamePlayData : NSObject


+(void)createDatabaseForFirstUse;



-(id)initWithZone:(NSInteger)zone;
-(QuizItem *)quizItemAtIndex:(NSInteger)index;
-(NSInteger)count;
-(void)save;
-(void)shuffleQuizData;

@end
