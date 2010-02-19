@import <Foundation/CPObject.j>

var wasntExpectingArguments = "Selector %@ wasn't expected to be called with arguments: %@!";
var wasntCalledEnough = "Selector %@ wasn't called enough times. Expected: %@ Got: %@";
var wasCalledTooMuch = "Selector %@ was called too many times. Expected: %@ Got: %@";

@implementation OJMoqAssert : CPObject

+ (void)selector:(SEL)selector hasBeenCalled:(int)times
{
	var comparisonResult = [selector compareTimesCalled:times];
	
	if(comparisonResult === CPOrderedAscending)
	{
		[self fail:[CPString stringWithFormat:wasntCalledEnough, [selector name], 
			times, [selector timesCalled]]];
	}
	else if(comparisonResult === CPOrderedDescending)
	{
		[self fail:[CPString stringWithFormat:wasCalledTooMuch, [selector name], 
			times, [selector timesCalled]]];
	}
}

+ (void)fail:(CPString)message
{
    [CPException raise:AssertionFailedError reason:message];
}

@end
