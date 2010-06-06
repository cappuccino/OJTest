@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import <Foundation/CPObject.j>
@import "OJCoverageSelector.j"

var og_objj_msgSend = objj_msgSend;
var og_class_addMethod = class_addMethod;
var og_class_addMethods = class_addMethods;

SHOULD_APPEND = YES;

@implementation OJCoverageListener : CPObject
{
    id          delegate            @accessors;
}

- (void)start
{
    objj_msgSend = function(aReceiver, aSelector) {
        if(aReceiver != null && delegate !== aReceiver && SHOULD_APPEND) {
            SHOULD_APPEND = NO;
            og_objj_msgSend(delegate, "calledMethod:", [OJCoverageSelector selectorWithObject:aReceiver selector:aSelector]);
            SHOULD_APPEND = YES;
        }
        
        return og_objj_msgSend.apply(this, arguments);
    }
    
    class_addMethod = function(aClass, aName, anImplementation, aType) {
        if(aClass != null)
        {
            var resolvedClass = objj_getClass(aClass.name);
            [delegate foundMethod:[OJCoverageSelector selectorWithClassName:resolvedClass selector:aName]];
        }
        
        og_class_addMethod(aClass, aName, anImplementation, aType);
    }
    
    class_addMethods = function(aClass, methods) {
        if(aClass != null)
        {
            var resolvedClass = objj_getClass(aClass.name);
            methods.map(function(method){[delegate foundMethod:[OJCoverageSelector 
                selectorWithClassName:resolvedClass selector:method.name]];});
        }
        
        og_class_addMethods.apply(this, arguments);
    }
}

- (void)stop
{
    objj_msgSend = og_objj_msgSend;
    class_addMethod = og_class_addMethod;
    class_addMethods = og_class_addMethods;
}

@end
