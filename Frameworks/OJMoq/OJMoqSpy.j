@import <Foundation/CPObject.j>
@import "OJMoqSelector.j"
@import "OJMoqAssert.j"

function spy(obj)
{
    return [OJMoqSpy spyOnBaseObject:obj];
}

@implementation OJMoqSpy : CPObject
{
    CPObject        _baseObject     @accessors(property=baseObject);
    CPArray         expectations;
    CPArray         selectors;
    CPArray         observedMethods;
    CPArray         stackMethodsCalled;
}

+ (OJMoqSpy)spyOnBaseObject:(id)baseObject
{
    return [[OJMoqSpy alloc] initWithBaseObject:baseObject];
}

- (id)init
{
    return [[OJMoqSpy alloc] initWithBaseObject:nil];
}

- (id)initWithBaseObject:(CPObject)baseObject
{
    if (self = [super init])
    {
        _baseObject = baseObject;
        observedMethods = [];
        [self reset];
    }

    return self;
}

- (void)reset
{
    expectations = [];
    selectors = [];
    stackMethodsCalled = [];
}

- (void)selector:(SEL)selector times:(CPNumber)times
{
    [self selector:selector times:times arguments:[]];
}

- (void)selector:(SEL)selector times:(CPNumber)times arguments:(CPArray)args
{
    [self replaceMethod:selector];

    var aSelector = [[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:args expectedTimesCalled:times],
        expectationFunction = function(){[OJMoqAssert selector:aSelector hasBeenCalled:times]; return aSelector;};

    if ([selectors containsObject:aSelector])
    {
        for (var i = 0; i < [selectors count]; i++)
        {
            var oldSelector = [selectors objectAtIndex:i];

            if ([oldSelector isEqual:aSelector])
            {
                var newTimes = [oldSelector expectedTimesCalled] + times;

                expectationFunction = function(){[OJMoqAssert selector:aSelector hasBeenCalled:newTimes]; return aSelector;}
                [aSelector setExpectedTimesCalled:newTimes];
                [oldSelector setExpectedTimesCalled:newTimes];
                [expectations replaceObjectAtIndex:i withObject:expectationFunction];
            }
        }
    }

    [expectations addObject:expectationFunction];
    [selectors addObject:aSelector];
}

- (void)verifyThatAllExpectationsHaveBeenMet
{
    [self verifyThatAllExpectationsHaveBeenMetInOrder:NO];
}

- (void)verifyThatAllExpectationsHaveBeenMetInOrder
{
    [self verifyThatAllExpectationsHaveBeenMetInOrder:YES];
}

- (void)verifyThatAllExpectationsHaveBeenMetInOrder:(BOOL)inOrder
{
    for (var i = 0; i < [expectations count]; i++)
    {
        var expectation = expectations[i],
            selector = expectation();

        if (!inOrder || ![selector timesCalled])
            continue;

        [OJMoqAssert selector:selector hasBeenCalledInOrderWithExpectedSelector:stackMethodsCalled.shift()];
    }
}

- (void)incrementNumberOfCallsForMethod:(SEL)selector arguments:(CPArray)userArguments
{
    var foundSelectors = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:userArguments]
                                          in:selectors ignoreWildcards:NO],
        count = [foundSelectors count];

    while (count--)
        [foundSelectors[count] call];
}

- (void)addCallOfMethod:(SEL)selector arguments:(CPArray)userArguments
{
    var foundSelectors = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:userArguments]
                                      in:selectors ignoreWildcards:NO],
    count = [foundSelectors count];

    if (count)
        [stackMethodsCalled addObject:[[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:userArguments]]
}

- (void)replaceMethod:(SEL)selector
{
    if ([observedMethods containsObject:selector])
        return;

    var aFunction = class_getMethodImplementation([_baseObject class], selector);
    class_replaceMethod([_baseObject class], selector,
        function(object, _cmd)
        {
            if (object === _baseObject)
            {
                var userArguments = Array.prototype.slice.call(arguments).splice(2, arguments.length);
                [self incrementNumberOfCallsForMethod:selector arguments:userArguments];
                [self addCallOfMethod:selector arguments:userArguments];
            }

            return aFunction.apply(this, arguments);
        });

    [observedMethods addObject:selector];
}

@end
