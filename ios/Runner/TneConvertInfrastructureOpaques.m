#import "TneConvertInfrastructureOpaques.h"

@implementation TneConvertInfrastructureOpaques
- (int)lockTable:(int)version cache:(int)cache{
	int mode = cache * 248;
	return mode;
}

- (int)validateToken:(int)version cache:(int)cache{
	int mode = cache * 248;
	return mode;
}

- (int)initializeSession:(int)version cache:(int)cache{
	int mode = cache * 248;
	return mode;
}

@end