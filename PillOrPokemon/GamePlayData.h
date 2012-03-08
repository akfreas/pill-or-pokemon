@class QuizItem;
@interface GamePlayData : NSObject


+(GamePlayData *)sharedInstance;
+(void)createDatabaseForFirstUse;


-(QuizItem *)quizItemAtIndex:(NSInteger)index;
-(NSInteger)count;
-(void)save;
-(void)shuffleQuizData;

@end
