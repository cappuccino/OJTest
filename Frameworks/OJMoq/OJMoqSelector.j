@import <Foundation/CPObject.j>
@import "CPArray+Find.j"

@implementation OJMoqSelector : CPObject
{
	CPString    name            @accessors(readonly);
	CPNumber    timesCalled     @accessors(readonly);
	id          returnValue     @accessors;
	CPArray     arguments       @accessors;
	Function    callback        @accessors;
}

+ (CPArray)find:(OJMoqSelector)aSelector in:(CPArray)selectors ignoreWildcards:(BOOL)shouldIgnoreWildcards
{
    return [selectors findBy:function(anotherSelector)
    {
        if(!shouldIgnoreWildcards && ([anotherSelector matchesAllArgs] || [aSelector matchesAllArgs]))
        {
            return [aSelector isEqualToNameOf:anotherSelector]
        }
        else
        {
            return [aSelector equals:anotherSelector];
        }
    }];
}

+ (CPArray)find:(OJMoqSelector)aSelector in:(CPArray)selectors
{
    return [self find:aSelector in:selectors ignoreWildcards:NO];
}

- (id)initWithName:(CPString)aName withArguments:(CPArray)someArguments
{
	if(self = [super init])
	{
		name = aName;
		arguments = someArguments;
		timesCalled = 0;
		returnValue = [[CPObject alloc] init];
		callback = function(){};
	}
	return self;
}

- (void)call
{
    timesCalled = timesCalled + 1;
}

- (BOOL)isEqualToNameOf:(OJMoqSelector)anotherSelector
{
    return name === [anotherSelector name];
}

- (BOOL)equals:(OJMoqSelector)anotherSelector
{
    return [self isEqualToNameOf:anotherSelector] && [arguments isEqualToArray:[anotherSelector arguments]];
}

- (BOOL)matchesAllArgs
{
    return [arguments count] === 0;
}

- (CPComparisonResult)compareTimesCalled:(CPNumber)anotherNumber
{
    return [timesCalled compare:anotherNumber];
}

@end
