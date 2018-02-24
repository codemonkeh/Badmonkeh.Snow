---
layout: post
title: DesignData makes your life easier
date: 2013-02-12 01:44
author: xian
comments: true
categories: Software Development
tags: .net, c#, design, DesignData, dev, silverlight, wp7, wp8, xaml
---
# Intro

Okay so I have finally jumped onto the band wagon and decided to apply my skills to Windows Phone development - after all I've had a Windows Phone since launch and I am a .NET developer. So really it's about time.

I won't go into the basics of how to start coding a Windows Phone application, the Windows Dev Centre really have that covered with a good variety of <a title="Windows Developer Center" href="http://msdn.microsoft.com/en-us/library/windowsphone/develop/ff402551(v=vs.105).aspx">simple articles</a>. What I will say however is that with XAML/Silverlight and a C# back-end, coding for Windows Phone is much like a marriage between ASP.NET and Win Forms, and a good one at that.

And without further adieu...

## On with the show

Soon enough after jumping into creating your first application, hopefully you are going to discover of the MVVM design pattern and start binding your controls to properties in a ViewModel. Or regardless binding your controls to an object of some kind.

Here's where there is a bit of a *Gotcha* moment, as you clear the dummy values and bind to the controls and for the most part discover that your interface is rather, well, blank. All of those lists and textboxes are not only empty but is most cases not visible at all.

If you are like me it is at this moment you go looking in the IDE for a suitable property to add testing data to, as seeing your UI in the Designer can sometimes be useful. And then there is the next *Gotcha*, there isn't one.

Microsoft in their wisdom, most likely to confuse developers, have not made it so easy for us. But have no fear there is a way, or truth be told a few, to add some test data to your design time UI.

#Option #1: FallbackValue

By far the easiest way to achieve this to specify a FallbackValue in the actual binding on the control. This will set a value to the control if the bound value is not available.

	<HyperlinkButton Content="{Binding FooterText, FallbackValue='Foo Bar'}" />

However the drawbacks of this method are that this value will also be shown at runtime if you have no bound value, and it won't do much for any control that expects a collection be bound to it.

# Option #2: Create a DesignData file

The next best option is to create a specific DesignData file that represents your ViewModel and contains data to be shown only at design time. This file will be written in XAML and allows you to set values for any of the public properties in your ViewModel, including any dependant types.

Now of course you could also use this method for any object you intend to set as the DataContext of a page or control, the method is much the same.

What you need to do in short is:

1. Create a text file and name it with a .xaml extension.
2. Add XAML representing your ViewModel (see below)
3. Set the BuildAction to DesignData, and clear the CustomTool property
4. In your control/page, ensure that the same namespace is also defined in your control/page's tag
5. Add a property to your PhoneApplicationPage (or any Control) referencing your new xaml page

	d:DataContext="{d:DesignData Source=/DesignData/MyViewModel.xaml}"

6. Then bind the control as you would normally.

## Creating the XAML DesignData file

	<local:MyViewModel xmlns:local="clr-namespace:Badmonkeh.ViewModels">
	   <MyViewModel.Items>
	      <local:MyViewModelItemCollection>
	         <local:MyViewModelItem Name="One two three four" Colour="Blue" PercentComplete="75" ShowProgress="True"/>
	      </local:MyViewModelItemCollection>
	   </local:MyViewModel.Items>
	</local:MyViewModel>

In this particular example I am representing a class named `MyViewModel` which has a `MyViewModelCollection` in a property named `Items`. This in turn contains a `MyViewModelItem` in its default property.

This is pretty standard XAML here, each property of a simple type is a simple key-value pair and each complex type must be described with a new XML element. Where a property for a complex time is not the default content property, a separate element must be created a referenced using the name of the parent class, e.g.
	
	<MyViewModel.Items>

The important things to note here:

* The declaration of the namespace corresponds to the class's full name
* Generic lists are not supported so you will have to extend your own collection
* Your ViewModel must have a public parameter-less constructor
* Only properties with backing fields can be bound (see below).


## A caveat and a solution
There is a caveat to this method, inherent in its design. What actually happens when you create a DesignData method is that the designer will create an instance of your class at design time where certain objects may not be available such as your data model, or IsolatedStorage.

The easiest away around this is of course to  simply use properties with backing fields but when that is not convenient you can get around this by checking if you are in design mode by calling `DesignerProperties.IsInDesignTool` and using a backed field only for design time.

	public string Comment
	{
	    get
	    {
	        if (DesignerProperties.IsInDesignTool)
	            return _designerComment;
	
	        if (_blog == null) return null;
	        return _blog.Comment;
	    }
	    set
	    {
	        if (DesignerProperties.IsInDesignTool)
	            _designerComment = value;
	        else
	            _blog.Comment = value;
	    }
	}

In the example you can see that I check if we're in the designer (or Blend for that matter) and use a backed field to avoid throwing an exception which would disable the design data, or returning null which would just disable the property.

You might of course wonder why go to the trouble of using a backing field when I can just return a testing value in the property? Well you're right, you can. However this will override any value you specify in the design data XAML file and if this class is shared with other pages, for instance if is used by a User Control, then you won't be able to create separate design data files for different pages.

# Conclusion
I have shown you a couple of ways to shows some design time data in your pages and help simplify the design process somewhat. The particular beauty of the second approach is that you can design your Control/Page first and really just consider the fields that you will need to bind to. At the time you just need to create a POCO class and only after the design is finalized implement your business logic.

Regardless I hope some of this was useful to you and if not, or if there is anything else I missed, hit me up in the comments below.
