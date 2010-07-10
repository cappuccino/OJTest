@import "../Frameworks/OJUnit/OJTestCase.j"
@import "../Frameworks/OJUnit/OJAssert.j"
@import "../Frameworks/OJMoq/OJMoq.j"

@implementation OJTestCaseTest : OJTestCase

- (void)testThatOJTestCaseDoesInitialize
{
   [OJAssert assertNotNull:[[OJTestCase alloc] init]];
}

- (void)testThatOJTestCaseDoesRunResults
{
	var result = moq([[OJTestResult alloc] init]);
	var target = [[OJTestCase alloc] init];
	
	[result selector:@selector(run:) times:1 arguments:[target]];
	
	[target run:result];
	
	[result verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJTestCaseDoesCreateDescription
{
	var target = [[OJTestCase alloc] init];
	
	[target setSelector:@selector(test:)];
	
	[OJAssert assert:@"[OJTestCase test:]" equals:[target description]];
}

- (void)testThatOJTestCaseDoesCallSetupAndTeardownWhenRunBare
{
	var target = [[OJTestCaseFake alloc] init];
	
	[target setSelector:@selector(selector)];
	
	[target runBare];
	
	[OJAssert assertTrue:[target setUpCalled] message:@"setUp wasn't called"];
	[OJAssert assertTrue:[target tearDownCalled] message:@"tearDown wasn't called"];
}

- (void)testThatOJTestCaseDoesRun
{
	[OJAssert assertNoThrow:function() { [[[OJTestCase alloc] init] run]; }];
}

@end

@implementation OJTestCaseFake : OJTestCase
{
	BOOL		setUpCalled		@accessors;
	BOOL		tearDownCalled	@accessors;
}

- (void)setUp
{
	setUpCalled = true;
}

- (void)tearDown
{
	tearDownCalled = true;
}

@end


