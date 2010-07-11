@import "../Frameworks/OJUnit/OJTestResult.j"
@import "../Frameworks/OJUnit/OJAssert.j"
@import "../Frameworks/OJMoq/OJMoq.j"

@implementation OJTestResultTest : OJTestCase
{
	OJTestResult		target;
}

- (void)setUp
{
	target = [OJTestResult createResult];
}

- (void)testThatOJTestResultDoesInitialize
{
	[OJAssert assertNotNull:[[OJTestResult alloc] init]]
}

- (void)testThatOJTestResultDoesCreateResult
{
	[OJAssert assertNotNull:[OJTestResult createResult]];
}

- (void)testThatOJTestResultIsSuccessfulWithNoErrorsOrFailures
{
	[OJAssert assertTrue:[target wasSuccessful]];
}

- (void)testThatOJTestResultDoesHaveZeroErrorsAndZeroFailures
{
	[OJAssert assert:0 equals:[target numberOfFailures]];
	[OJAssert assert:0 equals:[target numberOfErrors]];
}

- (void)testThatOJTestResultShouldStop
{
	[OJAssert assertFalse:[target shouldStop]];
	
	[target stop];
	
	[OJAssert assertTrue:[target shouldStop]];
}

- (void)testThatOJTestResultDoesAddError
{
	[target addError:[[CPException alloc] init] forTest:[[OJTestCase alloc] init]];
	[OJAssert assertFalse:[target wasSuccessful]];
	[OJAssert assert:1 equals:[target numberOfErrors]];
}

- (void)testThatOJTestResultDoesAddFailure
{
	[target addFailure:[[CPException alloc] init] forTest:[[OJTestCase alloc] init]];
	[OJAssert assertFalse:[target wasSuccessful]];
	[OJAssert assert:1 equals:[target numberOfFailures]];
}

- (void)testThatOJTestResultDoesIncreaseRunCount
{
	[target run:[[OJTestCase alloc] init]];
	
	[OJAssert assert:1 equals:[target runCount]];
}

- (void)testThatOJTestResultDoesIncreaseRunCountTwice
{
	[target run:[[OJTestCase alloc] init]];
	[target run:[[OJTestCase alloc] init]];

	[OJAssert assert:2 equals:[target runCount]];
}

- (void)testThatOJTestResultDoesStartTestOnListener
{
	var listener = moq([[OJTestListenerText alloc] init]);
	var test = [[OJTestCase alloc] init];
	
	[listener selector:@selector(startTest:) times:1 arguments:[test]];
	
	[target addListener:listener]
	[target startTest:test];
	
	[listener verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJTestResultDoesEndTestOnListener
{
	var listener = moq([[OJTestListenerText alloc] init]);
	var test = [[OJTestCase alloc] init];

	[listener selector:@selector(endTest:) times:1 arguments:[test]];

	[target addListener:listener]
	[target endTest:test];

	[listener verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJTestResultDoesAddFailureToListener
{
	var listener = moq([[OJTestListenerText alloc] init]);
	var test = [[OJTestCase alloc] init];
	var failure = [[CPException alloc] init];

	[listener selector:@selector(addFailure:forTest:) times:1 arguments:[failure, test]];

	[target addListener:listener]
	[target addFailure:failure forTest:test];

	[listener verifyThatAllExpectationsHaveBeenMet];
}

- (void)testThatOJTestResultDoesAddErrorToListener
{
	var listener = moq([[OJTestListenerText alloc] init]);
	var test = [[OJTestCase alloc] init];
	var error = [[CPException alloc] init];

	[listener selector:@selector(addError:forTest:) times:1 arguments:[error, test]];

	[target addListener:listener]
	[target addError:error forTest:test];

	[listener verifyThatAllExpectationsHaveBeenMet];
}

@end