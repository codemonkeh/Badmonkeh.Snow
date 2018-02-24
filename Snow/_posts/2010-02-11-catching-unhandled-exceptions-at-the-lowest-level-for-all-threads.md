---
layout: post
title: Catching unhandled exceptions at the lowest level for all threads
date: 2010-02-11
author: xian
comments: true
categories: Software Development
tags: c#, exception
---

# Catching unhandled exceptions at the lowest level for all threads

When designing a responsible application it always pays to think about exception handling. Of course it is good practice to not use "catch-all" exception blocks as this makes it easier to find bugs within the system. However when a user invariably finds one, you ideally don't want your application to just crash. You may wish to show them a pretty dialog, or in the very least log the exception details to help you fix it.

If you only ever use a single thread in your application then you can get away with the below:

    try
    {
    	Application.Run(new MyApp());
    }
    catch (Exception ex)
    {
    	//handle error here
    }

This happens to work well, however what if you are using separate threads to do processing so that you don't tie up the UI? These events will never be handled by this handled, and hence will crash your app.

The solution however is not that difficult. There are likely a few ways you could go about this but this one seems the easiest to me.
    
    static void Main()
    {
    	// this event handler works for all threads BUT the main thread
    	AppDomain.CurrentDomain.UnhandledException += new UnhandledExceptionEventHandler(CurrentDomain_UnhandledException);
    	// this event handler ONLY works for the main thread
    	Application.ThreadException += new System.Threading.ThreadExceptionEventHandler(Application_ThreadException);
    	// this ensures that the handler will ALWAYS get the event and so can't be reconfigured in the app.config
    	// this may or may not be applicable to you
    	Application.SetUnhandledExceptionMode(UnhandledExceptionMode.CatchException);
    	Application.Run(new MyApp());
    }
    
    private static void CurrentDomain_UnhandledException(object sender, UnhandledExceptionEventArgs e)
    {
    	HandleUnhandledException(e.ExceptionObject.ToString());
    }
    
    private static void Application_ThreadException(object sender, ThreadExceptionEventArgs e)
    {
    	HandleUnhandledException(e.Exception.ToString());
    }
    
    private static void HandleUnhandledException(string exceptionMessage)
    {
    	//log exception and show dialog here
    
    	Application.Exit();
    }

