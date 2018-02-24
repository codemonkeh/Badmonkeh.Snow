---
layout: post
title: Upgrading Castle Active Records
date: 2010-08-14
author: xian
comments: true
categories: Software Development
tags: castle, active records
---

# Upgrading Castle Active Records

From 1.0.3.0 (custom build) to 2.1.2

Downloaded binaries from http://sourceforge.net/projects/castleproject/files/ActiveRecord/2.1/AR%202.1.2.zip/download

I downloaded the binaries, and replaced my reference libraries. To my surprised there were no build errors.

Intrigued, i wandered onto the documentation to see what new features/syntax i could use.
Some notable things i found:

You can now initialise active records by just supplying an assembly, and letting it reflect the types for you.

    ActiveRecordsStarter.Initialize(Assembly assembly, IConfigurationSource source)

Warning: Try to create an Assembly exclusively for ActiveRecord types if you can. This overload will inspect all public types. If there are thousands of types, this can take a considerable amount of time.

Some validation attribute (Validators):

    ValidateIsUnique,ValidateRegExp,ValidateEmail,ValidateNonEmpty,ValidateConfirmation

Generics support:

extend generic base class `ActiveRecordBase<T>` or for inherent validation support extend `ActiveRecordValidationBase<T>`

Note however that if a record is invalid and you try to save it, it will throw an error. Be sure to check it's IsValid method first.

What doesn't work is my proxy class generation.

So i decided to upgrade to using the NHibernate Proxy Generators (http://sourceforge.net/projects/nhcontrib/files/NHibernate.ProxyGenerators/1.0.0%20Alpha%20564/)

Here's a how to: http://nhforge.org/wikis/howtonh/pre-generate-lazy-loading-proxies.aspx

Unfortunately i had the same issue as last time, that it just does not work for NHibernate 2.2

So i decided to have a play around with the source code a little.

* Converted the project to VS2010.
* Deleted all in libs except for IlMerge.exe
* Pasted new AR libs in there
* Set all projects target to .NET 3.5

`CastleStaticProxyFactory`
 - commented out //using NHibernate.Proxy.Poco.Castle;
 - replaced with NHibernate.ByteCode.Castle
 - changed CastleLazyInitializer to LazyInitializer
 
`CastleProxyFactoryFactory` : `IProxyFactoryFactory`
 - added stub method for `ProxyValidator`

`CastleStaticProxyFactoryFactory`
 - added stub method for `ProxyValidator`

Had to add reference to `NHibernate.ProxyGenerators.ActiveRecord` to the console project

Commented instantiation of `SessionFactory` - is this the right thing to do?

CastleProxyGenerator
 - commented out //using global::Castle.DynamicProxy;
	+ we want to use the new ProxyGenerator v2
 - added using Castle.DynamicProxy;
 - changed ModuleScope to save weakly named assembly only (to avoid an error) - moduleScope.SaveAssembly(false);
	+ for some reason a strongly named assembly doesn't contain the factory classes?
 - added compiler reference - references.Add(Assembly.Load("NHibernate.ByteCode.Castle"));, also Castle.ActiveRecord 
 - altered the compilation to add the input assemblies as references to creating the StaticProxyFactory

Removed Post Build Event:

    "$(SolutionDir)libs\NHibernateProxyGenerator\NPG.exe" /in:"$(TargetDir)BadMonkeh.DAO.dll" /out:"$(SolutionDir)BadMonkeh.Website\bin\BadMonkeh.DAO.Proxies.dll"
    copy "$(TargetPath)" "$(SolutionDir)BadMonkeh.Website\bin\$(TargetFileName)"