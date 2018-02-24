---
layout: post
title: Compiling Castle Active Records for a Partial Trust Environment
date: 2008-09-25
author: xian
comments: true
categories: Software Development
tags: .net, c#, nant, Castle, Active Records, ORM
---

# Compiling Castle Active Records for a Partial Trust Environment

Castle Active Record's is a brilliant object relational data-mapper that sits on top of nHibernate. Essentially this allows me to abstract the majority of my database calls away but creating a set of classes with a few additional properties attached to them.

I am currently using this system at work in several projects and personally i love it. It allows me to quickly reflect changes in the database, and the about 95% of all queries i can now write in code against objects.

## How to compile for partial trust

Checked out the latest source from SVN
Installed the latest version of nant 0.86b1
Put the nant bin directory in my path
Ran the following statement

    nant -D:common.testrunner.enabled=false -D:assembly.allow-partially-trusted-callers=true
    
It built successfully (for .net 3.5) with 2 non-fatal errors. Recommends a later version of nant (the nightly build)
Downloaded the latest nightly build (2008-08-18)
Recompiled using this nant with the same parameters
Built again with 2 non-fatal errors
And voila you should be done with your files in the "build" directory    

It's important to note that you can create the assemblies as unsigned (by specifying -D:sign=false) but this will cause you issues if you wish to enable lazy loading later on       
    
    D:\Dev\Tools\nant-0.86-nightly-2008-08-18\bin\nant -D:common.testrunner.enabled=false -D:assembly.allow-partially-trusted-callers=true
    
## Links:

* http://forum.castleproject.org/viewtopic.php?t=1439
* http://forum.castleproject.org/viewtopic.php?t=4659&sid=9a6619df040193fb021198a62f899cfd
* http://vhendriks.wordpress.com/2007/11/21/monorail-on-shared-hosting/