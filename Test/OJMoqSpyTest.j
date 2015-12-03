@import "../Frameworks/OJMoq/OJMoqSpy.j"
@import <OJSpec/OJSpec.j>

@implementation OJMoqSpyTest : OJTestCase

- (void)testThatOJMoqSpyDoesInitialize
{
    [[OJMoqSpy spyOnBaseObject:@"TEST"] shouldNotBeNil];
}

- (void)testThatOJMoqSpyDoesFailWhenSelectorNotCalled
{
    var spy = [OJMoqSpy spyOnBaseObject:@"TEST"];

    [spy selector:@selector(capitalizedString) times:1];

    [OJAssert assertThrows:function(){[spy verifyThatAllExpectationsHaveBeenMet]}];
}

- (void)testThatOJMoqSpyDoesDetectCallsOnObjects
{
    var target = @"TEST";
    var spy = [OJMoqSpy spyOnBaseObject:target];

    [spy selector:@selector(capitalizedString) times:1];

    [target capitalizedString];

    [spy verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqSpyDoesDetectCallsOnObjectsWithArgumentMatching
{
    var target = @"TEST";
    var spy = [OJMoqSpy spyOnBaseObject:target];

    [spy selector:@selector(substringFromIndex:) times:1 arguments:[1]];

    [target substringFromIndex:1];

    [spy verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqSpyDoesNotDetectCallsOnObjectsWithArgumentNotMatching
{
    var target = @"TEST";
    var spy = [OJMoqSpy spyOnBaseObject:target];

    [spy selector:@selector(substringFromIndex:) times:0 arguments:[1]];

    [target substringFromIndex:2];

    [spy verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqSpyDoesDetectInternalCallsOnObjects
{
    var target = [[TestObject alloc] init];

    var targetSpy = spy(target);

    [targetSpy selector:@selector(internalMethod) times:1];

    [target externalMethod];

    [targetSpy verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqSpyDoesNotBlockReturnValues
{
    var target = @"TEST";
    var spy = [OJMoqSpy spyOnBaseObject:target];

    [spy selector:@selector(characterAtIndex:) times:1 arguments:[1]];
    var charAtIndex = [target characterAtIndex:1];
    [spy verifyThatAllExpectationsHaveBeenMet];
    [OJAssert assert:charAtIndex equals:"E"];
}

@end

@implementation TestObject : OJTestCase

- (void)externalMethod
{
    [self internalMethod];
}

- (void)internalMethod
{
    // do nothing
}

@end
