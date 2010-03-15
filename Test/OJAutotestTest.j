@import "../Frameworks/OJAutotest/OJAutotest.j"
@import <OJMoq/OJMoq.j>

var OS = require("os");
var FSEVENTS = require("fsevents");

var oldSystem = OS.system;
var oldWatch = FSEVENTS.watch;

@implementation OJAutotestTest : OJTestCase

- (void)setUp
{
    OS.system = function(){return moq();};
    FSEVENTS.watch = function(){return moq();};
}

- (void)tearDown
{
    OS.system = oldSystem;
    FSEVENTS.watch = oldWatch;
}

- (void)testThatOJAutotestDoesInitialize
{
    var autotest = [[OJAutotest alloc] init];
    [self assertNotNull:autotest];
}

- (void)testThatOJAutotestDoesStartWithWatchedLocationTest
{
    var watchingTest = NO;
    FSEVENTS.watch = function(locationsToWatch, callback) {
        if(locationsToWatch[0] === "Test") {
            watchingTest = YES;
        }
    };
    
    var autotest = [OJAutotest startWithWatchedLocations:["Test"]];
    
    [self assertTrue:watchingTest];
}

- (void)testThatOJAutotestDoesStartWithWatchedLocationTestAndLib
{
    var watchingTest = NO;
    FSEVENTS.watch = function(locationsToWatch, callback) {
        if(locationsToWatch[0] === "Test" && locationsToWatch[1] === "lib") {
            watchingTest = YES;
        }
    };

    var autotest = [OJAutotest startWithWatchedLocations:["Test", "lib"]];

    [self assertTrue:watchingTest];   
}

@end