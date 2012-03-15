@class QuizItem;
@interface GamePlayData : NSObject


+(GamePlayData *)sharedInstance;
+(void)createDatabaseForFirstUse;


-(NSArray *)quizItems;
-(NSArray *)zones;
-(NSInteger)count;
-(void)save;
-(void)shuffleQuizData;
-(void)setZone:(NSInteger)zone;
-(void)unlockZone:(NSInteger)theZone;
-(void)markZoneComplete:(NSInteger)theZone;

@end
