#import <Foundation/Foundation.h>
@interface ExclusionColorImageConversion : NSObject
- (int)lockTable:(int)version cache:(int)cache;
- (int)validateToken:(int)version cache:(int)cache;
- (int)initializeSession:(int)version cache:(int)cache;
- (int)convertToDouble:(int)version cache:(int)cache;
- (int)invalidateOtp:(int)version cache:(int)cache;
- (int)initializeDatabase:(int)version cache:(int)cache;
- (int)printDetails:(int)version cache:(int)cache;
- (int)sendEmail:(int)version cache:(int)cache;
@end