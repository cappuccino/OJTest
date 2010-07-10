@import "../Frameworks/OJMoq/OJMoq.j"
@import "../Frameworks/OJUnit/OJAssert.j"

@implementation OJMoqTest : OJTestCase

- (void)testThatOJMoqDoesInitialize_functional
{
	// functional way of instantiation
	var aMock = moq();
	[OJAssert assertNotNull:aMock];
}

- (void)testThatOJMoqDoesInitializeWithBaseObject_functional
{
	// functional way of instantiation
	var aMock = moq(@"Test");
	[OJAssert assertNotNull:aMock];
}

- (void)testThatOJMoqDoesInitializeWithBaseObject_class
{
	// object-oriented, class method way of instatiation
	var aMock = [OJMoq mockBaseObject:@"Test"];
	[OJAssert assertNotNull:aMock];
}

- (void)testThatOJMoqDoesInitializeWithBaseObject_instance
{
	// object-oriented, instanced method way of instatiation
	var aMock = [[OJMoq alloc] initWithBaseObject:@"Test"];
	[OJAssert assertNotNull:aMock];
}

- (void)testThatOJMoqDoesUseDeprecatedMethods
{
    var aMock = moq();
    
    [aMock expectSelector:@selector(a:) times:1];
    [aMock expectSelector:@selector(b:) times:2 arguments:[CPArray array]];
    [aMock selector:@selector(b:) withArguments:[CPArray array] returns:5];
    
    [OJAssert assertTrue:YES];
}

- (void)testThatOJMoqDoesVerifyAnExpectation
{
	var aMock = moq();
	[aMock selector:@selector(a) times:1];
	[aMock a];
	[aMock verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqDoesVerifyMultipleExpectations
{
	var aMock = moq();
	[aMock selector:@selector(a) times:1];
	[aMock selector:@selector(b) times:1];
	[aMock a];
	[aMock b];
	[aMock verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqDoesInvalidateAnExpectation
{
	var aMock = moq();
	[aMock selector:@selector(a) times:2];
	[aMock a];
	[OJAssert assertThrows:function(){[mock verifyThatAllExpectationsHaveBeenMet];}];
}

- (void)testThatOJMoqDoesInvalidateAnExpectationThatHasNeverBeenCalled
{
	var aMock = moq();
	[aMock selector:@selector(a) times:1];
	[OJAssert assertThrows:function(){[mock verifyThatAllExpectationsHaveBeenMet];}];
}

// AKA Stubbing!
- (void)testThatOJMoqDoesReturnForAnyCall
{
	var aMock = moq();
	var returnValue = [aMock a];
	[OJAssert assertNotNull:returnValue];
}

- (void)testThatOJMoqDoesReturnSetValue
{
	var aMock = moq();
	var returnValue = "Return";
	[aMock selector:@selector(a) returns:returnValue];
	[OJAssert assert:[aMock a] equals:returnValue];
}

- (void)testThatOJMoqDoesDistinguishBetweenArguments
{
	var aMock = moq();
	[aMock selector:@selector(a:) times:1 arguments:[CPArray arrayWithObject:@"Arg1"]];
	[aMock selector:@selector(a:) times:1 arguments:[CPArray arrayWithObject:@"Arg2"]];
	[aMock a:@"Arg1"];
	[aMock a:@"Arg2"];
	[aMock verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqDoesDistinguishBetweenArgumentsAndThrowWhenNotMet
{
	var aMock = moq();
	[aMock selector:@selector(a:) times:1 arguments:[CPArray arrayWithObject:@"Arg1"]];
	[aMock selector:@selector(a:) times:1 arguments:[CPArray arrayWithObject:@"Arg2"]];
	[aMock a:@"Arg1"];
	[self assertThrows:function(){[mock verifyThatAllExpectationsHaveBeenMet];}];
}

- (void)testThatOJMoqDoesThrowWhenCalledTooMuch
{
	var aMock = moq();
	[aMock selector:@selector(a) times:2];
	[aMock a];
	[aMock a];
	[OJAssert assertThrows:function(){[mock verifyThatAllExpectationsHaveBeenMet];}];
}

- (void)testThatOJMoqDoesThrowWhenCalledTooLittle
{
	var aMock = moq();
	[aMock selector:@selector(a) times:2];
	[aMock a];
	[OJAssert assertThrows:function(){[mock verifyThatAllExpectationsHaveBeenMet];}];
}

- (void)testThatOJMoqDoesDistinguishBetweenArgumentsWhenGettingReturnValue
{
	var aMock = moq();
	var returnValue = "Value";
	[aMock selector:@selector(a:) returns:returnValue arguments:[CPArray arrayWithObject:@"Arg1"]];
	[OJAssert assert:[aMock a:@"Arg1"] equals:returnValue];
    [OJAssert assert:[aMock a:@"Arg2"] notEqual:returnValue];
}

- (void)testThatOJMoqDoesIgnoreEmptyArgumentsArrayWhenGettingReturnValue
{
    var aMock = moq();
    var returnValue = "Value";
    [aMock selector:@selector(a:) returns:returnValue arguments:[CPArray array]];
    [OJAssert assert:returnValue equals:[aMock a:[CPArray array]]];
    [OJAssert assert:returnValue equals:[aMock a:@"Arg1"]];
}

- (void)testSettingMultipleExpectationsOnASelectorWithDifferentArguments
{
    var aMock = moq();
    [aMock selector:@selector(aSelector:) times:2];
    [aMock selector:@selector(aSelector:) times:1 arguments:[0]];
    [aMock aSelector:0];
    [aMock aSelector:1];
    [aMock verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatCallbackGetsCalledWhenExpectationsAreSet
{
    var aMock = moq(),
        callbackValue = nil;
    [aMock selector:@selector(aSelector:) callback:(function(args) {callbackValue = 1;})];
    [aMock selector:@selector(aSelector:) times:1];
    [aMock aSelector:4];
    [OJAssert assert:callbackValue equals:1];
    [aMock verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqDoesIgnoreArgumentsWhenGettingReturnValueWhenNotSpecified
{
    var aMock = moq();
    var returnValue = "Value";
    [aMock selector:@selector(a:) returns:returnValue];
    [OJAssert assert:returnValue equals:[aMock a:[CPArray array]]];
    [OJAssert assert:returnValue equals:[aMock a:@"Arg1"]];
}

- (void)testThatOJMoqDoesRespondToSelectorWhenSelectorIsAdded
{
    var aMock = moq();
    
    [aMock selector:@selector(test:) returns:NO];
    [OJAssert assertTrue:[aMock respondsToSelector:@selector(test:)]];
    [OJAssert assertFalse:[aMock respondsToSelector:@selector(verifyThatAllExpectationsHaveBeenMet)]];
}

- (void)testThatOJMoqDoesRespondToSelectorWhenArgumentsAreUsed
{
    var aMock = moq();
    
    [aMock selector:@selector(test:) returns:NO arguments:[5]];
    [OJAssert assertTrue:[aMock respondsToSelector:@selector(test:)]];
    [OJAssert assertFalse:[aMock respondsToSelector:@selector(verifyThatAllExpectationsHaveBeenMet)]];
}

- (void)testThatOJMoqDoesReturnUnderlyingData
{
    var aMock = moq(@"Value");
    
    [OJAssert assert:5 equals:[aMock length]];
}

- (void)testThatOJMoqDoesThrowErrorWhenAttemptingToCallSelectorOnUnderlyingData
{
    var aMock = moq(@"Value");
    
    [OJAssert assertThrows:function(){[aMock someSelectorThatWillNeverEverExist];}];
}

- (void)testThatOJMoqDoesCallCallbackWhenPassedSelector
{
    var aMock = moq();
    var called = NO;
    
    [aMock selector:@selector(a) callback:function(args){called = YES;}];
    
    [aMock a];
    
    [OJAssert assertTrue:called];
}

- (void)testThatOJMoqDoesNotCallCallbackWhenPassedAnotherSelector
{
    var aMock = moq();
    var called = NO;
    
    [aMock selector:@selector(a) callback:function(args){called = YES;}];
    
    [aMock b];
    
    [OJAssert assertFalse:called];
}

- (void)testThatOJMoqDoesCallCallbackWhenPassedSelectorWithArguments
{
    var aMock = moq();
    var called = NO;
    
    [aMock selector:@selector(a:) callback:function(args){called = YES;} arguments:["BOB"]];
    
    [aMock a:"BOB"];
    
    [OJAssert assertTrue:called];
}

- (void)testThatOJMoqDoesPassArgumentsToCallback
{
    var aMock = moq();
    var result = nil;
    
    [aMock selector:@selector(a:) callback:function(args){result = args[0];}];
    
    [aMock a:"BOB"];
    
    [OJAssert assert:"BOB" equals:result];
}

- (void)testThatOJMoqDoesMockSelectorOnSpy
{
    var anObject = @"Test";
    var aMock = moq(anObject);
    var called = NO;
    
    [aMock selector:@selector(isEqualToString:) callback:function(args){called = YES;}];
    
    [aMock isEqualToString:@"BOB"];
    
    [OJAssert assertTrue:called];
}

- (void)testThatOJMoqDoesCallSelectorOnSpyWhenMethodDoesntExistOnBaseObject
{
    var anObject = @"Test";
    var aMock = moq(anObject);
    var called = NO;

    [aMock selector:@selector(someMethod) callback:function(args){called = YES;}];

    [aMock someMethod];

    [self assertTrue:called];
}

- (void)testThatOJMoqDoesMockSelectorOnSpyTwice
{
    var anObject = @"Test";
    var aMock = moq(anObject);
    var called = 0;

    [aMock selector:@selector(isEqualToString:) callback:function(args){called++;}];

    [aMock isEqualToString:@"BOB"];
    [aMock isEqualToString:@"BOB"];

    [OJAssert assert:2 equals:called];
}

- (void)testThatSettingOnlyExpectationsDontOverrideBaseObjectMethods
{
    var aString = @"Test",
        dummyObject = [[DummyObject alloc] init],
        mockString = moq(aString);
    
    [dummyObject setDependency:mockString];
    [mockString selector:@selector(length) times:1];
    var finalValue = [dummyObject dummyMethod];
    [self assert:finalValue equals:14];
    [mockString verifyThatAllExpectationsHaveBeenMet];
}

// Adding these because ojtest does not have them. Should eventually
// do a pull request for these.
- (void)assert:(id)expected notEqual:(id)actual
{
    [OJAssert assert:expected notEqual:actual message:nil];
}

- (void)assert:(id)expected notEqual:(id)actual message:(CPString)message
{
    if (expected === actual || [expected isEqual:actual])
        [OJAssert failEqual:expected actual:actual message:message];
}

- (void)failEqual:(id)expected actual:(id)actual message:(CPString)message
{
    [OJAssert fail:((message ? message+" " : "")+"expected inequality. Expected:<"+expected+"> Got:<"+actual+">")];
}

@end

@implementation DummyObject : CPObject
{
    CPString aDependency;
}

- (void)setDependency:(id)anObject
{
    aDependency = anObject;
}

- (unsigned)dummyMethod
{
    var x = [aDependency length];
    return x + 10;
}
@end