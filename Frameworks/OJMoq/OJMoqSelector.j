@import <Foundation/CPObject.j>
@import "CPArray+Find.j"
@import "CPArray+DeepEqual.j"

@implementation OJMoqSelector : CPObject
{
    CPArray     args                    @accessors;
    CPNumber    expectedTimesCalled     @accessors;
    CPNumber    timesCalled             @accessors(readonly);
    CPString    name                    @accessors(readonly);
    Function    callback                @accessors;
    id          returnValue             @accessors;
}

+ (CPArray)find:(OJMoqSelector)aSelector in:(CPArray)selectors ignoreWildcards:(BOOL)shouldIgnoreWildcards
{
    return [selectors findBy:function(anotherSelector)
    {
        if(!shouldIgnoreWildcards && ([anotherSelector matchesAllArgs] || [aSelector matchesAllArgs]))
            return [aSelector isEqualToNameOf:anotherSelector]
        else
            return [aSelector equals:anotherSelector];
    }];
}

+ (CPArray)find:(OJMoqSelector)aSelector in:(CPArray)selectors
{
    return [self find:aSelector in:selectors ignoreWildcards:NO];
}

- (id)initWithName:(CPString)aName withArguments:(CPArray)someArguments
{
    return [self initWithName:aName withArguments:someArguments expectedTimesCalled:0];
}

- (id)initWithName:(CPString)aName withArguments:(CPArray)someArguments expectedTimesCalled:(CPNumber)anExpectedTimesCalled
{
    if (self = [super init])
    {
        args                = someArguments;
        callback            = undefined;
        expectedTimesCalled = anExpectedTimesCalled;
        name                = aName;
        returnValue         = undefined;
        timesCalled         = 0;
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
    return [self isEqualToNameOf:anotherSelector] && [args deepEqual:[anotherSelector args]];
}

- (BOOL)isEqual:(OJMoqSelector)anotherSelector
{
    return [self equals:anotherSelector];
}

- (BOOL)matchesAllArgs
{
    return [args count] === 0;
}

- (CPComparisonResult)compareTimesCalled:(CPNumber)anotherNumber
{
    return [timesCalled compare:anotherNumber];
}

@end
