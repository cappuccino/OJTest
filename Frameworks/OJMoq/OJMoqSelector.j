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

+ (OJMoqSelector)find:(OJMoqSelector)aSelector in:(CPArray)selectors
{
    return [selectors findBy:function(anotherSelector)
    {
        if([anotherSelector numberOfArguments] > 0)
        {
            return [aSelector equals:anotherSelector]
        }
        else
        {
            return [aSelector isEqualToNameOf:anotherSelector];
        }
    }];
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

- (CPNumber)numberOfArguments
{
    return [arguments count];
}

- (CPComparisonResult)compareTimesCalled:(CPNumber)anotherNumber
{
    return [timesCalled compare:anotherNumber];
}

@end
