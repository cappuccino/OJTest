@import "../OJSpecMatcher.j"

@implementation OJSpecShouldBeInstanceOf : OJSpecMatcher
{
}

- (BOOL)matches:(id)actual
{
    return [super matches:[actual class]];
}

- (BOOL)doesNotMatch:(id)actual
{
    return [super doesNotMatch:[actual class]];
}

@end

/**
 * Checks if an object is an instance of the expected class
 */
@implementation CPObject (ShouldBeInstanceOfMatcher)

- (void)shouldBeInstanceOf:(Class)expected
{
    [[[OJSpecShouldBeInstanceOf alloc] initWithExpected:expected] matches:self];
}

- (void)shouldNotBeInstanceOf:(Class)expected
{
    [[[OJSpecShouldBeInstanceOf alloc] initWithExpected:expected] doesNotMatch:self];
}

@end
