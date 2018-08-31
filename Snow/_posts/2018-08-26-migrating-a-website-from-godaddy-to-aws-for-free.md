---
layout: post
title: Migrating a website from GoDaddy to AWS for free
date: 2018-08-26
author: xian
comments: true
categories: Software Development
tags: web hosting, aws
---

# Migrating a website from GoDaddy to AWS for free

Okay so this post has been sitting on the back burner for a while because i have been busy with a new job, but i just wanted to write a little something up about migrating a website to AWS.

In my situation i had been using GoDaddy as a host for some time however i have never been particularly happy with either their performance or value and i had wanted to find another host for a while.

As it happens AWS has a free tier that makes a low traffic website like practically free to host, with excellent reliability and performance. So it was a bit of a no brainer.

I should note that as website is generated from from markdown using Sandra.Snow, it is effectively has no server-side rendering and this guide would be suitable for similar static websites. It is definitely possible to host server side rendered websites and APIs on AWS, but that may cost a little more and is beyond the scope of this article.

## Migration process

This guide largely follows [Vicky Lai's excellent guide](https://vickylai.io/verbose/aws-static-site) which itself uses the an [AWS Guide](https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html) but i'll help you out with some of the GoDaddy particulars.

### Create a website 

1. Sign up at https://aws.amazon.com/free/
2. Create AWS Bucket(s) to store your website contents
	a. Use the guide here: https://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html
	b. Create buckets for your domain and each sub domain (even if they are only for url redirection) with default settings your region, e.g.
		i. badmonkeh.com
		ii. www.badmonkeh.com
3. Use a tool such as Cloud Berry to upload website content to your main S3 bucket (the one without a subdomain), e.g badmonkeh.com
4. Assign the policy to make the bucket contents publicly accessible
5. Enable static website hosting in bucket properties for the main bucket
	a. Properties -> Static Website Hosting
	b. Use this bucket to host a website
	c. Configure default page
	d. Note the endpoint url e.g. http://badmonkeh.com.s3-website-ap-southeast-2.amazonaws.com
6. Redirect requests for your 'www' subdomain bucket to your main S3 bucket
	a. Properties -> Static Website Hosting
	b. Redirect requests to main bucket name, e.g. badmonkeh.com
7. (Optional) configure website / bucket logging - (I skipped this but it is a good idea)
	a. https://docs.aws.amazon.com/AmazonS3/latest/dev/LoggingWebsiteTraffic.html

##### Tips:

* You need an S3 bucket for every subdomain (including "www") as well as one for your domain

### DNS Routing

When it comes to DNS routing you have two options, you can either continue to use your domain registrars DNS server, e.g. GoDaddy, or you can set up Route 53. 

Using Route 53 is ideal if you plan to migrate your domain name over, however this will incur a small fee (USD 0.50 / month at time of writing) so bare this into consideration.

#### Using Route 53

1. Export DNS records from yuor existing host, e.g. GoDaddy
    1. GoDaddy > DNS Management
    2. Advanced Features > Export Zones File (Windows)
2. Set up DNS routing using Route 53 Hosted Zone
    a. AWS > Route 53 > Create Hosted Zone
    a. Create Hosted Zone for your domain name, e.g. badmonkeh.com
	b. Add alias for your domain and "www" subdomain, e.g. badmonkeh.com and www.badmonkeh.com
		i. Create Record Set
			1) Alias: Yes
			2) Alias Target: select s3 bucket name, e.g. badmonkeh.com (s3-website-ap-southeast-2.amazonaws.com)
6. Migrate DNS records to Route 53
	a. Import Zone File (copy and paste)
		i. NS - Instead of transferring these, replace their values with the name server values that are provided by Amazon Route 53. 
		ii. SOA - Amazon Route 53 provides this record in the hosted zone with a default value. 
7. Migrate DNS records in GoDaddy
		i. Deleted any subdomain records, they will be recreated later
		ii. Disabled domain forwarding
		iv. Disabled DNS record management 

##### Tips:

* Make sure you migrate all records, such as MX records to allow custom email providers
* You may have to delete some entries, such as "@" entries to make the file importable
* You can always add the records line by line if there are any issues


#### Using GoDaddy 

I have found the migrating my domain to GoDaddy was relatively easy and definitely cheaper and i will write this up in a future article.

However if you plan to keep your domain with GoDaddy you can continue to use their DNS servers, you will just need to update your DNS records.

1. Update GoDaddy DNS record
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

### Conclusion

Overall the process is relatively straight forward and offers many potential benefits, but i do encourage you to do your own research and determine if this is suitable for your requirements. 

Further enhancements would be to migrate your domain names and use a CDN such as AWS's CloudFront.
