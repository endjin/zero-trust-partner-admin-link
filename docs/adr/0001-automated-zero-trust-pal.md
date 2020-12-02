# Automated Zero Trust PAL

## Status

Proposed

## Context

Some customers who operate in regulated industries or offer SaaS products to their end customers, require Zero Trust environments; meaning that 3rd parties (including Microsoft Partners) should not have access to any environment which contains PII, financial or medical data. This requirement is often backed by legal contracts with the customer's end-customer, who are often also regulated. Although this offers benefits to the 3rd parties around mitigating risk and liability, and limits GDPR responsibilities, it causes problems with access rights based attribtuion of Azure Consumed Revenue (ACR), required for partner competency consumption targets.

The process for creating a Zero Trust Partner Admin Link is as follows

1) The Partner creates an Enterprise Application in their Tenant. This acts as the root identity and connects the Partner to the Customer.
2) The Customer exports their list of subscriptions as a CSV, which then can then edit to remove any non-relevant subscriptions.
3) The Customer (with the relevant permissions) creates a Service Principal tied to The Partner's Enterprise Application, and then removed the credentials so that The Partner does not have access. 

## Decision

We can automate this process by encapsulating it in three PowerShell Cmdlets packaged as a module on the [PowerShell Gallery](https://www.powershellgallery.com/).

`New-ZeroTrustPartnerAdminLinkPartnerIdentity` - run by the Partner to generate the "root" identity in the Partner Tenant. This forms the connection between the Partner and the Customer. 
`Export-CustomerSubscriptionsAsCsvForPartnerAdminLink` - run by the customer to generate a CSV file listing their Azure Subscriptions. They can edit to remove 
`Set-ZeroTrustPartnerAdminLink`

## Consequences

