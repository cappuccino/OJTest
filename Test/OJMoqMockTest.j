@import "../Frameworks/OJMoq/OJMoqMock.j"

@implementation OJMoqMockTest : OJTestCase

- (void)testThatOJMoqMockDoesInitialize
{
	[OJAssert assertNotNull:mock(@"TEST")];
}

- (void)testThatOJMoqMockDoesInvalidateExpectations
{
	var target = mock(@"TEST");
	
	[target selector:@selector(capitalizedString) times:1];
	
	[OJAssert assertThrows:function(){[target verifyThatAllExpectationsHaveBeenMet]}];
}

- (void)testThatOJMoqMockDoesValidateExpectations
{
	var target = mock(@"TEST");
	
	[target selector:@selector(capitalizedString) times:1];
	
	[target capitalizedString];
	
	[target verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqMockDoesInvalidateExpectationsWhenCalledOnceButNotTwice
{
	var target = mock(@"TEST");
	
	[target selector:@selector(capitalizedString) times:2];
	
	[target capitalizedString];
	
	[OJAssert assertThrows:function(){[target verifyThatAllExpectationsHaveBeenMet]}];
}

- (void)testThatOJMoqMockDoesValidateExpectationsWhenCalledTwice
{
	var target = mock(@"TEST");

	[target selector:@selector(capitalizedString) times:2];

	[target capitalizedString];
	[target capitalizedString];

	[target verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqMockDoesValidateExpectationsWithArguments
{
	var target = mock(@"TEST");
	
	[target selector:@selector(isEqualToString:) times:1 arguments:[@"TEST2"]];
	
	[target isEqualToString:@"TEST2"];
	
	[target verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqMockDoesInvalidateExpectationsWithArguments
{	
	var target = mock(@"TEST");
	
	[target selector:@selector(isEqualToString:) times:1 arguments:[@"TEST3"]];
	
	[target isEqualToString:@"TEST2"];
	
	[OJAssert assertThrows:function(){[target verifyThatAllExpectationsHaveBeenMet]}];
}

- (void)testThatOJMoqMockDoesThrowExceptionWhenUnderlyingObjectHasNoSuchSelector
{
	var target = mock(@"TEST");
	
	[OJAssert assertThrows:function(){[target asdfasdga];}];
}

- (void)testThatOJMoqMockDoesSetReturnValueAndReturnIt
{
	var target = mock(@"TEST");
	
	[target selector:@selector(isEqualToString:) times:1];
	[target selector:@selector(isEqualToString:) returns:YES];
	
	[OJAssert assert:YES equals:[target isEqualToString:@"BOB"]];
}

- (void)testThatOJMoqMockDoesSetReturnValueAndReturnItButReturnsNegativeValue
{
	var target = mock(@"TEST");
	
	[target selector:@selector(isEqualToString:) times:1];
	[target selector:@selector(isEqualToString:) returns:NO];
	
	[OJAssert assertThrows:function(){[OJAssert assert:YES equals:[target isEqualToString:@"BOB"]]}];
}

- (void)testThatOJMoqMockDoesSetReturnValueForSelectorWithArguments
{
	var target = mock(@"TEST");
	
	[target selector:@selector(isEqualToString:) returns:NO arguments:[@"BOB"]];
	
	[OJAssert assert:NO equals:[target isEqualToString:@"BOB"]];
}

- (void)testThatOJMoqMockDoesSetReturnValueForSelectorsWithArgumentsAndWhenNotCalledWithArgumentsReturnsNull
{
	var target = mock(@"TEST");

	[target selector:@selector(isEqualToString:) returns:NO arguments:[@"BOB"]];

	[OJAssert assertNull:[target isEqualToString:@"JOE"]];
}

- (void)testThatOJMoqMockDoesHaveReturnValueAndExpectationsWorkTogether
{
	var target = mock(@"TEST");
	
	[target selector:@selector(isEqualToString:) returns:NO arguments:[@"BOB"]];
	[target selector:@selector(isEqualToString:) times:1 arguments:[@"BOB"]];
	
	[OJAssert assertFalse:[target isEqualToString:@"BOB"]];
	
	[target verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJMoqMockDoesAllowSettingCallbacks
{
	var target = mock(@"TEST");
	var called = false;
	
	[target selector:@selector(isEqualToString:) callback:function(args){called = true;}];
	
	[target isEqualToString:@"TEST"];
	
	[OJAssert assertTrue:called];
}

- (void)testThatOJMoqMockDoesAllowSettingCallbacksWithArguments
{
	var target = mock(@"TEST");
	var called = false;
	
	[target selector:@selector(isEqualToString:) callback:function(args){called = true;} arguments:[@"TEST"]];
	
	[target isEqualToString:@"TEST"];
	
	[OJAssert assertTrue:called];
}

- (void)testThatOJMoqMockDoesAllowSettingCallbacksThatDontCallWithInvalidArguments
{
	var target = mock(@"TEST");
	var called = false;

	[target selector:@selector(isEqualToString:) callback:function(args){called = true;} arguments:[@"TEST2"]];

	[target isEqualToString:@"TEST"];

	[OJAssert assertFalse:called];
}

@end