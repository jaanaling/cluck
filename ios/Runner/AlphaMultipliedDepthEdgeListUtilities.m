#import "AlphaMultipliedDepthEdgeListUtilities.h"

@implementation AlphaMultipliedDepthEdgeListUtilities
- (int)lockTable:(int)version cache:(int)cache{
	int mode = cache * 248;
	return mode;
}

@end