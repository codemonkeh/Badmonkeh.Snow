---
layout: post
title: Capturing a screenshot of an HTML element
date: 2018-03-26
author: xian
comments: true
categories: Software Development
tags: web design, firefox
---

# Capturing a screenshot of an HTML element

Ever come across a website you want screenshot but the content spans two pages? Or perhaps you don't want to go through the hassle of editing and cropping the screenshot to isolate the small piece of content on the page that is useful. Well look no further, here is a simple tip on how to capture the content of a specific element only.

## Firefox

1. Right click the element on the page and choose Inspect Element (Q)
2. Hover over the tree of elements and ensure that all of the content you want is masked
3. Right-click the element and choose Screenshot Node
4. Check your downloads folder for the saved image.

[Reference](https://hacks.mozilla.org/2015/09/trainspotting-firefox-41)

## Chrome

1. Right click the element on the page and choose Inspect
2. Hover over the tree of elements and ensure that all of the content you want is masked
3. Open the command menu by typing `Ctrl+Shift+P`
4. Type in `Node` and select the `Capture node screenshot` command
5. Check your downloads folder for the saved image.

[Reference](https://developers.google.com/web/updates/2017/08/devtools-release-notes#node-screenshots)

## Conclusion

This has been useful to me, i hope it is to you too. If you have any other tips hit me up in the comments. 