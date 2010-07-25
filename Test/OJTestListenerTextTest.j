@import "../Frameworks/OJUnit/OJTestListenerText.j"

@implementation OJTestListenerTextTest : OJTestCase

- (void)testThatOJTestListenerTextDoesInitialize
{
	[OJAssert assertNotNull:[[OJTestListenerText alloc] init]];
}

- (void)testThatOJTestListenerDoesAddErrors
{
	var listener = [[OJTestListenerText alloc] init];
	
	[listener addError:[[OJTestFailure alloc] initWithTest:[[OJTestCase alloc] init] exception:[[CPException alloc] init]]];
	
	[OJAssert assert:1 equals:[[listener errors] count]];
}

- (void)testThatOJTestListenerTextDoesAddFailures
{
	var listener = [[OJTestListenerText alloc] init];

	[listener addFailure:[[OJTestFailure alloc] initWithTest:[[OJTestCase alloc] init] exception:[[CPException alloc] init]]];

	[OJAssert assert:1 equals:[[listener failures] count]];
}

@end