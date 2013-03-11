var assert = require("assert");

@implementation CPArray(DeepEqual)

- (BOOL)deepEqual:(id)anArray
{
    if (self === anArray)
        return YES;

    if (self.length != anArray.length)
        return NO;

    var index = 0,
        count = [self count];

    for(; index < count; ++index)
    {
        var lhs = self[index],
            rhs = anArray[index];

        // If both objects are objective-j objects
        if (lhs && lhs.isa && rhs && rhs.isa)
        {
            if ([lhs respondsToSelector:@selector(deepEqual:)])
            {
                if (![lhs deepEqual:rhs]) 
                    return NO;
            }
            else if (![lhs isEqual:rhs])
               return NO;
        }

        // If only one of the objects is an objective-j object
        else if ((lhs && lhs.isa && (!rhs || !rhs.isa) ||
                  rhs && rhs.isa && (!lhs || !lhs.isa)))
            return NO;

        // Both are pure JS objects
        else if (!deepEqual(self[index], anArray[index]))
            return NO;
    }

    return YES;
}

@end

var deepEqual = function(obj1, obj2)
{
    var isEqual;
    assert.pass = function() {
        isEqual = true;
    }
    assert.fail = function() {
        isEqual = false;
    }
    assert.deepEqual(obj1, obj2);
    return isEqual;
}