OJTest
======

OJTest is a collection of Frameworks and Tools that aim to provide a comprehensive testing solution for Cappuccino applications.

Frameworks
==========

* OJUnit - an xUnit framework
* OJMoq  - a mocking framework
* OJSpec - a specification framework

Tools
=====

* OJAutotest - a tool to automatically test your Cappuccino application when you make changes
* OJCov - a coverage tool to help you identify code not covered by tests

Installation
============

First, you need to have narwhal installed. You can check that it is installed by doing the following:

    js --version

If narwhal is not installed, you can install it by running:

    $(which wget || echo "curl -O") http://github.com/280north/cappuccino/raw/master/bootstrap.sh && sudo bash bootstrap.sh
    
After that, you can just do

    sudo tusk install http://github.com/280north/OJTest/zipball/latest
    
And the libraries will be installed. OJAutotest has some other external dependencies that you need to install separately. You can find [installing instructions on the wiki](http://wiki.github.com/280north/OJTest/ojautotest).

Please keep in mind that the master branch is an actively developed branch and that you should most likely be pulling from stable branches. Latest is a tag that will keep you up to date with the latest stable branch.

Contributors
============

* Klaas Pieter Annema
* Paul Baumgart
* Ross Boucher
* Antonio Salazar Cardozo
* Saikat Chakrabarti
* Andreas Falk
* Martin Häcker
* Derek Hammer
* Chandler Kent
* Tom Robinson
* Jared Santo
