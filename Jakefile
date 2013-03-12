#!/usr/bin/env narwhal

JAKE = require("jake");
SYSTEM = require("system");
FILE = require("file");
OS = require("os");
FileList = JAKE.FileList;

JAKE.task ("docs", ["documentation"]);

JAKE.task ("documentation", function()
{
    if (executableExists("doxygen"))
    {
        if (OS.system(["ruby", FILE.join("documentation", "make_headers")]))
            OS.exit(1); //rake abort if ($? != 0)

        if (OS.system(["doxygen", FILE.join("documentation", "OJTest.doxygen")]))
            OS.exit(1); //rake abort if ($? != 0)
    }
    else
        print("doxygen not installed. skipping documentation generation.");
});

JAKE.task("test", function(){
    var tests = new FileList('Test/*Test.j');
    var cmd = ["bin/ojtest"].concat(tests.items());
    var cmdString = cmd.map(OS.enquote).join(" ");
    var cmdString = "env OBJJ_INCLUDE_PATHS='./Frameworks' " + cmdString;

    var code = OS.system(cmdString);
    if (code !== 0)
        OS.exit(code);
});

executableExists = function(/*String*/ aFileName)
{
    return SYSTEM.env["PATH"].split(':').some(function(/*String*/ aPath)
    {
        return FILE.exists(FILE.join(aPath, aFileName));
    });
}
