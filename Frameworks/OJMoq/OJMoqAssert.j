@import <Foundation/CPObject.j>

@class OJMoqSelector

var wasntExpectingArguments = "Selector %@ wasn't expected to be called with arguments: %@!",
    wasntCalledEnough = "Selector %@ wasn't called enough times. Expected: %@ Got: %@",
    wasCalledTooMuch = "Selector %@ was called too many times. Expected: %@ Got: %@",
    wasntCalledInTheGoodOrder = "Selector %@ with args %@ was not called in the good order. Expected: %@ with args %@";

@implementation OJMoqAssert : CPObject

+ (void)selector:(OJMoqSelector)selector hasBeenCalled:(int)times
{
    var comparisonResult = [selector compareTimesCalled:times];

    if (comparisonResult === CPOrderedAscending)
    {
        [self fail:[CPString stringWithFormat:wasntCalledEnough, [selector name],
            times, [selector timesCalled]]];
    }
    else if (comparisonResult === CPOrderedDescending)
    {
        [self fail:[CPString stringWithFormat:wasCalledTooMuch, [selector name],
            times, [selector timesCalled]]];
    }
}

+ (void)selector:(OJMoqSelector)selector hasBeenCalledInOrderWithExpectedSelector:(OJMoqSelector)expectedSelector
{
    if (![selector equals:expectedSelector])
        [self fail:[CPString stringWithFormat:wasntCalledInTheGoodOrder, [selector name], [selector args], [expectedSelector name], [expectedSelector args]]];
}

+ (void)fail:(CPString)message
{
    [CPException raise:AssertionFailedError reason:message];
}

@end
