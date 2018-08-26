---
layout: post
title: Migrating a static website from GoDaddy to AWS for free
date: 2018-08-26
author: xian
comments: true
categories: Software Development
tags: web hosting, aws
---

## Let's talk for a moment

Okay so this post has been sitting on the back burner for a while because at first i wanted to evaluate AWS for a while and then i forgot and got busy finding a new job. But now we are back in the moment and wile the creative juices are temporarily flowing let us put pen to paper, or as it were text to screen, and get on with this.

Did you know that you can host a website on AWS for practically nothing? No i am serious, AWS have a free tier which has a bunch of free stuff for a year and other stuff that is free up until a certain limit! Case in point if you have a low traffic blog or website such as this one you can gain a lot of performance for very little from your pocket so if you don't know about this head over [here](https://aws.amazon.com/free/) now!

## The GoDaddy thing

In my situation i had been using GoDaddy as a host for some time as at one point i thought it was a cost effective way to host my blog which was written as custom .NET web app. I can't say i was ever really satisfied with either their performance or the value of their proposition but i continued because it wasn't really that expensive (and i had a habit of forgetting the renewal date ;)).

Over time i realised that there was little value maintaing my own blog engine and i switched it to WordPress, before finally deciding to ditch back-end content generation entirely and use Sandra.Snow to pre-process it into a purely static website for best performance. Of course that is a story for another day, but this left me with an ideal website to move straight into an AWS S3 bucket as it does not need any particular.

## Migration process

Following article: https://vickylai.io/verbose/aws-static-site/

1. Sign up at https://aws.amazon.com/free/
2. Create AWS Bucket(s) to store website contents
	a. From: https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html
	b. Created buckets with default settings in Asia Pacific (Sydney) for my domain name, e.g.
		i. badmonkeh.com
		ii. www.badmonkeh.com
3. Upload content to badmonkeh.com S3 bucket
4. Assigned policy to make badmonkeh.com bucket contents publicly accessible
5. Enabled static website hosting in bucket properties for badmonkeh.com
	a. Properties -> Static Website Hosting
	b. Use this bucket to host a wesbite
	c. Configure default page
	d. Note the endpoint url -> 
	http://badmonkeh.com.s3-website-ap-southeast-2.amazonaws.com
6. Redirect requests for www.badmonkeh.com bucket to badmonkeh.com
	a. Properties -> Static Website Hosting
	b. Redirect requests to badmonkeh.com
7. (Optional) configure website / bucket logging - skipped
	a. https://docs.aws.amazon.com/AmazonS3/latest/dev/LoggingWebsiteTraffic.html
8. Set up DNS routing using Route 53 Hosted Zone
	a. Create Hosted Zone for badmonkeh.com
	b. Add alias for badmonkeh.com and www.badmonkeh.com
		i. Create Record Set
			1) Alias: Yes
			2) Alias Target: select s3 bucket name, e.g. Badmonkeh.com (s3-website-ap-southeast-2.amazonaws.com)
9. Migrate DNS records to Route 53
	a. Don't transfer these DNS records:
		i. NS - Instead of transferring these, replace their values with the name server values that are provided by Amazon Route 53. 
		ii. SOA - Amazon Route 53 provides this record in the hosted zone with a default value. 
	b. Migrate DNS records in GoDaddy
		i. I deleted subdomain records, can recreate these later
		ii. I disabled domain forwarding
		iii. Updating name servers to the name server values that are provided by Amazon Route 53. E.g. ns-618.awsdns-13.net
		iv. DNS record management is no longer maintained by godaddy.
	c. Add new MX record in AWS to allow GoDaddy to forward my mail
		0 	smtp.secureserver.net
		10 	mailstore1.secureserver.net
10. (Alternative) Just update GoDaddy DNS record (this is also free, Route53 incurs a small cost)
	a. Find website's static subdomain
		i. Log-in to AWS
		ii. Go to S3
		iii. Select website bucket e.g. www.badmonkeh.com
		iv. Go to Properties
		v. Copy Endpoint, e.g. http://badmonkeh.com.s3-website-ap-southeast-2.amazonaws.com 
	b. Update GoDaddy DNS record
		i. Log in to GoDaddy
		ii. Go to DNS Management
		iii. Change CNAME with host "www"
			1) Points To: "@", Change to endpoint value (without protocol, just the subdomain)
