@import <Foundation/Foundation.j>

@import "OJTestResult.j"
@import "OJAssert.j"

/*!
    A single test case. This is an abstract superclass that each of your test cases (which are
    usually in their own separate files and of which each tests one and only one class) should
    subclass. Each of these test cases have the ability to run seperately.

    Example:

        @implementation OJMoqTest : OJTestCase

        ... // tests and other files

        @end

    In order to increase readability, there is a conventional way of writing tests. Each test
    should be prepended by the word "test" and non-tests should not be prepended by the word
    "test".

    Example:

        - (void)testThatOJMoqDoesInitialize {} // a test
        - (OJMoq)createStandardOJMoqInstance {return nil;} // a non-test

    Before each test, the message "setUp" will be passed to your test. By default, this does
    nothing but you can override the "setUp" method to do something for your test.

    After each test, the message "tearDown" will be passed to your test. By default, this
    does nothing but you can override the "tearDown" method to do something for your test.

    @brief A single test case.
 */
@implementation OJTestCase : CPObject
{
    SEL _selector       @accessors(property=selector);
}

/*!
   Runs the tests and returns the result.
 */
- (async OJTestResult)run
{
    var result = [OJTestResult createResult];
    await [self run:result];
    return result;
}

/*!
    Run the tests using the given OJTestResult handler.
    @param result the OJTestResult to run the tests
 */
- (async void)run:(OJTestResult)result
{
    await [result run:self];
}

/*!
   Runs the setup, test and teardown for the current test selector.
 */
- (async void)runBare
{
    [self setUp];
    try
    {
        await [self runTest];
    }
    finally
    {
        [[CPRunLoop currentRunLoop] limitDateForMode:CPDefaultRunLoopMode];
        [self tearDown];
    }
}

/*!
    Send the test class the setUp message.
*/
- (void)setUpClass
{
    [[self class] setUp];
}

/*!
    Send the test class the tearDown message.
*/
- (void)tearDownClass
{
    [[self class] tearDown];
}

/*!
    Run the test(s) for the current selector.
 */
- (async void)runTest
{
    [OJAssert assertNotNull:_selector];

    await [self performSelector:_selector];
}

/*!
   SetUp method that is called before each run.
 */
- (void)setUp
{
}

/*!
   TearDown method that is called after each run.
 */
- (void)tearDown
{
}

/*!
   SetUp method that is called once before launching the test
 */
+ (void)setUp
{
}

/*!
   TearDown method that is called once after launching the test
 */
+ (void)tearDown
{
}

/*!
   The number of test cases this represents.

    @returns 1
 */
- (int)countTestCases
{
    return 1;
}

- (CPString)description
{
    return "[" + [self className] + " " + _selector + "]";
}

@end

//@import "OJTestCase+Assert.j"
