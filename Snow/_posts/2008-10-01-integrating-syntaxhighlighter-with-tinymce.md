---
layout: post
title: Integrating SyntaxHighlighter with TinyMCE
date: 2008-10-01
author: xian
comments: true
categories: Software Development
tags: SyntaxHighlighter, TinyMCE
---

# Integrating SyntaxHighlighter with TinyMCE

SyntaxHighlighter is a fantastic set of js libraries that allow you ... <INSERT BLURB>

This article assumes that you have already installed TinyMCE (perhaps add part about installing and configuring TinyMCE??)

1. Download SyntaxHighlighter <INSERT LINK>

2. Install
    - i just copied the css file into my theme, and the js files into a folder under my scripts dir (~/jscripts/SyntaxHighlighter)
    
3. Download Nawaf's codehighlighter plugin from here (http://weblogs.asp.net/nawaf/archive/2008/04/10/syntaxhighlighter-plug-in-for-tinymce-3-x-wysiwyg-editor.aspx)
   Just scroll down to the bottom of the page, where it lists attachment <perhaps link to better download>
   
4. Extract this into TinyMCE's plugin directory

5. Now the next step is to modify your TinyMCE configuration to include the following:
    plugins: 'codehighlighting',
    extended_valid_elements: 'textarea[name|class|cols|rows]',
    remove_linebreaks : false,
    theme_advanced_buttons3_add : 'codehighlighting'
    
    Where you place the button, as defined on the last line above is up to you consult the <INSERT LINK> wiki for more info.
    
6. Now all is left to do is to load syntax highlighter on the page you intend to use it. Of course you could manually code this into the page
   but as i would generally use this within a control i created a class to insert the correct javascript. Now all you have to do is call the
   static methods in the Page_Load of your control.
   
public class ClientScriptHelper
{
    public static void RegisterSyntaxHighlighter(Page page)
    {
        page.ClientScript.RegisterClientScriptInclude("shCore", 
            page.ResolveClientUrl("~/jscripts/SyntaxHighlighter/shCore.js"));
        page.ClientScript.RegisterClientScriptInclude("shBrushCSharp", 
            page.ResolveClientUrl("~/jscripts/SyntaxHighlighter/shBrushCSharp.js"));
        page.ClientScript.RegisterClientScriptInclude("shBrushXml", 
            page.ResolveClientUrl("~/jscripts/SyntaxHighlighter/shBrushXml.js"));

        string clipboardPath = page.ResolveClientUrl("~/jscripts/SyntaxHighlighter/clipboard.swf");
        page.ClientScript.RegisterStartupScript(typeof(ClientScriptHelper), "SyntaxHighlighterInit", @"
            <script language='javascript'>
                dp.SyntaxHighlighter.ClipboardSwf = '" + clipboardPath + @"';
                dp.SyntaxHighlighter.HighlightAll('code');
            </script>   
        ");
    }

    public static void RegisterTinyMCEFull(Page page)
    {
        page.ClientScript.RegisterClientScriptInclude("TinyMCE", 
            page.ResolveClientUrl("~/jscripts/tiny_mce/tiny_mce.js"));
        page.ClientScript.RegisterClientScriptBlock(typeof(ClientScriptHelper), "TinyMCEInit", @"
            <script type='text/javascript'>
                tinyMCE.init({
                    mode: 'textareas',
                    theme: 'advanced',
                    fix_list_elements: true,
                    plugins: 'emotions,codehighlighting',
                    theme_advanced_buttons3_add: 'emotions, codehighlighting',
                    extended_valid_elements: 'textarea[name|class|cols|rows]',          
                    remove_linebreaks : false
                });
            </script>
        ");
    }
}    

    Please note above that the initialisation for the SyntaxHighligter is done after the page has loaded. If you are
    going to enter this manually, put that block *at the bottom of the page* or it might not work correctly.

    The benefits of doing it this way are:
        1. I only have to type it in one place and can reuse it in many
        2. I can dynamically load the libraries (which do take a little while) based upon my own parameters
        3. I can customise the layout based upon my own parameters
        4. They are all registered with the same type, so multiple controls on one page can call this and still have it register only once
        5. I don't have to worry about initalising the SyntaxHightlighter in the right place
        
And that should be all you really need to know

References:
-----------
http://weblogs.asp.net/nawaf/archive/2008/04/10/syntaxhighlighter-plug-in-for-tinymce-3-x-wysiwyg-editor.aspx
http://weblogs.asp.net/nawaf/archive/2008/04/06/syntaxhighlighter-plugin-for-tinymce-wysiwyg-editor.aspx