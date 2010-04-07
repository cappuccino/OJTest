@implementation CPArray (Find)

- (CPArray)findBy:(Function)isTheObject
{
    var foundObjects = [];
    for(var i = 0; i < [self count]; i++)
    {
        if(isTheObject([self objectAtIndex:i]))
        {
            [foundObjects addObject:[self objectAtIndex:i]];
        }
    }
	
    return foundObjects;
}

@end
