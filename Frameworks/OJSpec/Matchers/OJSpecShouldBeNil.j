
@import "../OSMatcher.j"

@implementation OSShouldBeNil : OSMatcher
{
}

@end


/**
 * Checks if an object is nil.
 */
@implementation CPObject (ShouldBeNilMatcher)

- (void)shouldBeNil
{
    if(![[[OSShouldBeNil alloc] initWithExpected:nil] matches:self])
        throw SpecFailedException;
}

- (void)shouldNotBeNil
{
    if([[[OSShouldBeNil alloc] initWithExpected:nil] matches:self])
        throw SpecFailedException;
}

@end