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
    CPArray observedMethods;
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
    if(self = [super init]) {
        _baseObject = baseObject;

        expectations = [];
        selectors = [];
        observedMethods = [];
    }
    return self;
}

- (void)reset
{
    expectations = [];
    selectors = [];
}

- (void)selector:(SEL)selector times:(CPNumber)times
{
    [self selector:selector times:times arguments:[]];
}

- (void)selector:(SEL)selector times:(CPNumber)times arguments:(CPArray)args
{
    [self replaceMethod:selector];

    var aSelector = [[OJMoqSelector alloc] initWithName:sel_getName(selector) withArguments:args];
    var expectationFunction = function(){[OJMoqAssert selector:aSelector hasBeenCalled:times];};
    [expectations addObject:expectationFunction];
    [selectors addObject:aSelector];
}

- (void)verifyThatAllExpectationsHaveBeenMet
{
    expectations.forEach(function(expectation){
        expectation();
    });
}

- (void)incrementNumberOfCallsForMethod:(SEL)selector arguments:(CPArray)userArguments
{
    var foundSelectors = [OJMoqSelector find:[[OJMoqSelector alloc] initWithName:sel_getName(selector)
                                        withArguments:userArguments] in:selectors ignoreWildcards:NO],
        count = [foundSelectors count];

    while (count--)
        [foundSelectors[count] call];
}

- (void)replaceMethod:(SEL)selector
{
    if ([observedMethods containsObject:selector])
        return;

    var aFunction = class_getMethodImplementation([_baseObject class], selector);
    class_replaceMethod([_baseObject class],
        selector,
        function(object, _cmd) {
            if(object === _baseObject) {
                var userArguments = Array.prototype.slice.call(arguments).splice(2, arguments.length);
                [self incrementNumberOfCallsForMethod:selector arguments:userArguments];
            }
            return aFunction.apply(this, arguments);
        });

    [observedMethods addObject:selector];
}

@end
