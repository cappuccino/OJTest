#!/usr/bin/env objj

@import <OJUnit/OJTestRunnerText.j>

var SYSTEM = require("system");
var OS = require("os");
var FILE = require("file");
var GROWLER_SCRIPT_OPTIONS = "-w -n OJAutotest -p 0 --image '%@' -m '%@' '%@' '' &";
var ERROR_IMAGE = FILE.join(SYSTEM.prefix, "packages", "ojtest", "images", "error.png");
var SUCCESS_IMAGE = FILE.join(SYSTEM.prefix, "packages", "ojtest", "images", "success.png");

var stream = require("term").stream;

@implementation OJAutotestRunnerText : OJTestRunnerText

- (void)report
{
    var totalErrors = [[_listener errors] count] + [[_listener failures] count];

    if (!totalErrors) {
        var growlArguments = [CPString stringWithFormat:GROWLER_SCRIPT_OPTIONS, SUCCESS_IMAGE, "All tests passed!", "OJAutotest Success!"];
        var growlCommand = "ojautotest-growl " + growlArguments;
        OS.system(growlCommand+growlArguments);
        
        stream.print("\0green(All tests passed in the test suite.\0)");
        return CPLog.info("End of all tests.");
    }
    
    var growlArguments = [CPString stringWithFormat:GROWLER_SCRIPT_OPTIONS, ERROR_IMAGE, totalErrors+" failures!", "OJAutotest Failed!"];
    var growlCommand = "ojautotest-growl " + growlArguments;
    OS.system(growlCommand+growlArguments);

    stream.print("Test suite failed with \0red(" + [[_listener errors] count] + 
        " errors\0) and \0red(" + [[_listener failures] count] + " failures\0).");
    CPLog.info("Test suite failed with "+[[_listener errors] count]+" errors and "+[[_listener failures] count]+" failures.");
    
    [self exit];
}

@end

function main(args) {
    runner = [[OJAutotestRunnerText alloc] init];
    [runner startWithArguments:args.slice(1)];
}
