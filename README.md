# Introduction

DevSecOps & Zero Trust are central to endjin's Cloud Adoption Framework approach. Many of endjin's customers operate in regulated industries, and thus it is highly undesirable for external partners to have access to any environment that contains customer data. Although this does cause day-to-day complications for partners, it is also highly desirable, as it mitigates security and professional indemnity risks, and minimises GDPR obligations by limiting access. 

But operating in this Zero Trust way causes additional complications for partners who need ACR to maintain their Microsoft Partner Competencies, as the Partner Admin Link (PAL) approach is designed to prove that partner are actively driving consumption by proving that they have at least contributor rights to a subscription, resource group or resource.

This repository provides an approach for configuring Partner Admin Link in a Zero Trust way, that enables the customer to have protected subscriptions, but also allows the partner to prove that their workloads are running in those Zero Trust environments.

## Instructions for The Partner

Share your MPN Id with the Customer, this should be the Location or HQ based Id and not a Virtual Org.

## Instructions for The Customer

In a PowerShell Command Prompt:

`Import-Module .\ZeroTrust.PAL.psd1 -force`

Then run:

`Export-CustomerSubscriptionsAsCsvForPartnerAdminLink -Path .\customer-subs.csv`

When prompted, you will need to authenticate.

Open the `customer-subs.csv` remove any subscriptions that you do not want to assign PAL to for The Partner, and then save the file.

Then run:

`Set-ZeroTrustPartnerAdminLink -PartnerName Contoso -MpnId <PROVIDED BY THE PARTNER> -SubscriptionsCsv .\customer-subs.csv`

When prompted, you will need to authenticate as an account that has permissions to manage Azure Active Directory (AAD) applications and perform ARM role assignments across the subscriptions in the above file.

### Optional Parameters

| Name | Description | Default |
|------|-------------|---------|
|Role|Controls which role is assigned to the AAD identity that links the Partner. Valid options: `Owner`, `Contributor` or `Support Request Contributor`|Support Request Contributor|
|AppNamePrefix|Used to name the AAD Application with the convention '\<AppNamePrefix>-\<PartnerName>' (e.g. `Microsoft-Partner-Admin-Link-Identity-Contoso`) |Microsoft-Partner-Admin-Link-Identity|

## How does this Achieve Zero-Trust?

* The Partner requires no access to the Customer tenant as part of the linking process that signifies Partner contribution
* The credentials associated with the AAD Application that links the Partner contribution expire after 10 minutes, and are not exposed outside the automated process
* The Customer retains full control over the AAD identity that links the Partner contribution and, if necessary, can easily break the link by deleting the AAD Application

## Disclaimer

Whilst this automated process has been built using the available guidance from Microsoft (see links below), this repository does not represent an officially sanctioned Microsoft approach.

* https://docs.microsoft.com/en-us/azure/cost-management-billing/manage/link-partner-id
* https://partner.microsoft.com/en-US/resources/collection/partner-admin-link#/


## Caveat Emptor

This is an open-source project that aims to address the issues of enabling Microsoft's Partner Admin Link in Zero-Trust environments.  You should perform your own due diligence on whether the approach is consistent with your organisation's security posture & policies.

## Licenses

[![GitHub license](https://img.shields.io/badge/License-Apache%202-blue.svg)](https://github.com/endjin/zero-trust-partner-admin-link/blob/main/LICENSE)

This project is available under the Apache 2.0 open source license.

For any licensing questions, please email [&#108;&#105;&#99;&#101;&#110;&#115;&#105;&#110;&#103;&#64;&#101;&#110;&#100;&#106;&#105;&#110;&#46;&#99;&#111;&#109;](&#109;&#97;&#105;&#108;&#116;&#111;&#58;&#108;&#105;&#99;&#101;&#110;&#115;&#105;&#110;&#103;&#64;&#101;&#110;&#100;&#106;&#105;&#110;&#46;&#99;&#111;&#109;)

## Project Sponsor

This project is sponsored by [endjin](https://endjin.com), a UK based Microsoft Gold Partner for Cloud Platform, Data Platform, Data Analytics, DevOps, a Power BI Partner, and .NET Foundation Corporate Sponsor.

We help small teams achieve big things.

For more information about our products and services, or for commercial support of this project, please [contact us](https://endjin.com/contact-us). 

We produce two free weekly newsletters; [Azure Weekly](https://azureweekly.info) for all things about the Microsoft Azure Platform, and [Power BI Weekly](https://powerbiweekly.info).

Keep up with everything that's going on at endjin via our [blog](https://blogs.endjin.com/), follow us on [Twitter](https://twitter.com/endjin), or [LinkedIn](https://www.linkedin.com/company/1671851/).

Our other Open Source projects can be found on [our website](https://endjin.com/open-source)

## Code of conduct

This project has adopted a code of conduct adapted from the [Contributor Covenant](http://contributor-covenant.org/) to clarify expected behavior in our community. This code of conduct has been [adopted by many other projects](http://contributor-covenant.org/adopters/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [&#104;&#101;&#108;&#108;&#111;&#064;&#101;&#110;&#100;&#106;&#105;&#110;&#046;&#099;&#111;&#109;](&#109;&#097;&#105;&#108;&#116;&#111;:&#104;&#101;&#108;&#108;&#111;&#064;&#101;&#110;&#100;&#106;&#105;&#110;&#046;&#099;&#111;&#109;) with any additional questions or comments.