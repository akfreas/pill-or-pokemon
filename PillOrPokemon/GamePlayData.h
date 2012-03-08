@class QuizItem;
@interface GamePlayData : NSObject


+(GamePlayData *)sharedInstance;
+(void)createDatabaseForFirstUse;


-(NSArray *)quizItems;
-(NSInteger)count;
-(void)save;
-(void)shuffleQuizData;
-(void)setZone:(NSInteger)zone;

@end
