---
layout: post
title: Adding a reusable pop-up box using jQuery and ASP.NET
date: 2008-12-31
author: xian
comments: true
categories: Software Development
tags: dialog, popup, jQuery, asp.net, javascript
---

# Adding a reusable pop-up box using jQuery and ASP.NET

Using jQuery it is simple to create and show a modal pop-up box with transitional effects. For this guide i sue the code from http://yensdesign.com/2008/09/how-to-create-a-stunning-and-smooth-popup-using-jquery/, but implement it in a reusable way.

Please note that this works perfectly in Firefox and IE7. To get this to work in IE6 you must set the document type to HTML 4.01 STRICT! Don't blame me, blame Microsoft for their buggy software.

Now if you have not already done so i'd advise you to create a ClientScriptHelper class to handle loading javascript classes.

In particular i created methods to load jQuery from the google website, and to load the popup.js which will get into detail below:

    public static void RegisterJQueryRemote(Page page)
    {
        page.ClientScript.RegisterClientScriptInclude("jQuery", "http://jqueryjs.googlecode.com/files/jquery-1.2.6.min.js");
    }

    public static void RegisterPopup(Page page)
    {
        page.ClientScript.RegisterClientScriptInclude("popup", page.ResolveClientUrl("~/jscripts/jQuery/popup.js"));
    }
	
These methods are just a convenience and allow us to programmtically register the required javascript, if you prefer you can register the scripts yourself manually.

Now the javascript required for all the loading, hiding and transitional effects i extracted from the above guide and massage to suit my purposes. This i store in a javascript file popup.js as mentioned above. 

This code has been made generic to enable to easily create a popup on any page, however is only designed for a single popup. If you were to have multiple popups you would need to modify the javascript.

Okay so presuming you have installed the script on your own server the steps to implementing your own popup are as follows:

1. include jQuery and the popup.js
	Personally i call the above methods in the `Page_Load` event
	
2. create a div with a class "popup", and into this place the code for your popup, e.g.

```
  <div id="popup" class="help_titles">
    <div>
        <a id="popupClose">x</a>
        <strong>Rejection Reason</strong>
    </div>                       
    <p>
        <asp:TextBox ID="txtRejectionReason" runat="server" />
        <asp:Button ID="btnRejectWithReason" Text="Reject" runat="server" />
    </p>
  </div>
```  
	  
3. create a div with class "backgroundPopup"
	This just needs to be empty, and will be used to dim the background
	
4. Add a div/span called "popupButton" and put a link or button inside it. This will be used to launch your pop-up.

```
	  <div id="popupButton"><a>Reject</a></div>	  
	  <span id="popupButton"><input type="button" value="Reject"/></span>
```

5. And finally add the required styles. 	 

```
    #backgroundPopup { 
        display: none;   
        _position: absolute; /* hack for internet explorer 6*/
        position: fixed;
        height: 100%;   
        width: 100%;   
        top: 0;   
        left: 0;   
        background: #000000;   
        border: 1px solid #cecece;   
        z-index: 1; 
    }	    	    
    #popup {  
        width: 300px; 
        margin-top: 5px; 
        padding-bottom: 5px; 
        display: none;
        _position: absolute; /* hack for internet explorer 6*/
        position: fixed;
        z-index: 2; 
        height: 100px;
    }
    #popup div { background-color: #E6E6E6; width: 100%; height: 30px; padding-top: 5px }
    #popup p { margin: 5px; }
    #popupClose { padding-right: 5px; float: right; font-weight: bold; }        
    #popupClose:hover { cursor: pointer; }
    #popupButton { width: 100%; margin-top: 5px; }        

    .help_titles
    {
        border: solid 1px #B5B6B5;
        background-color: #F7F7F7;
        font-family: Verdana, Arial;
        font-size: 11px;
        color: #1C1F7B;
    }
```    
		
Obviously you do not need all of this, you can remove the formatting. But this should get you started.
	
And that's about it really.