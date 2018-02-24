---
layout: post
title: CSS Minimum height
date: 2008-12-04
author: xian
comments: true
categories: Software Development
tags: css, styling
---

# CSS Minimum height

I have come to love using a CSS design over ugly, change resistant tables. However the eternal annoyance is getting the design to work correctly with Internet Explorer as well as lovely standards compliant browsers.

One main issue i have is getting a div to have a minimum height specified for all browsers so it doesn't squash up when there is no content. Here is a nice way to do it:

    #main {
      height: auto !important; /* IE6 ignores */
      height: 500px; /* IE6 uses this as specified later */
      min-height: 500px;
    }

The first line is for Firefox, the middle for IE6 and the last for IE7. Works like a charm :)