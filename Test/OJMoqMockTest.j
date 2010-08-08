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

@end