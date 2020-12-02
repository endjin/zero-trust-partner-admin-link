# Automated Zero Trust PAL

## Status

Proposed

## Context

Some customers who operate in regulated industries or offer SaaS products to their end customers, require Zero Trust environments; meaning that 3rd parties (including Microsoft Partners) should not have access to any environment which contains PII, financial or medical data. This requirement is often backed by legal contracts with the customer's end-customer, who are often also regulated. Although this offers benefits to the 3rd parties around mitigating risk and liability, and limits GDPR responsibilities, it causes problems with access rights based attribtuion of Azure Consumed Revenue (ACR), required for partner competency consumption targets.

The process for creating a Zero Trust Partner Admin Link is as follows:

1) The Partner creates an Multi-tenant Azure AD Application in their Tenant. This acts as the root identity and connects the Partner to the Customer.
2) The Customer exports their list of subscriptions as a CSV, which then can then edited to remove any non-relevant subscriptions.
3) The Customer (with the relevant permissions) creates a Service Principal tied to The Partner's Multi-tenant Azure AD Application, and retains complete controls over the associated credentials that need not be shared with The Partner.

## Decision

We can automate this process by encapsulating it in three PowerShell Cmdlets packaged as a module available from the [PowerShell Gallery](https://www.powershellgallery.com/).

`New-ZeroTrustPartnerAdminLinkPartnerIdentity` - run by The Partner to generate the Multi-tenant Azure AD Application which acts as the "root" identity in the Partner Tenant. This forms the connection between the Partner and the Customer. 
`Export-CustomerSubscriptionsAsCsvForPartnerAdminLink` - run by The Customer to generate a CSV file listing their Azure Subscriptions. This can be edited to remove non-applicable subscriptions.
`Set-ZeroTrustPartnerAdminLink` - run by The Customer to create the Service Principal linked to The Partner's Multi-tenant Azure AD Application. Then assigns this Service Principal the "Contributor Role" to each of the subscriptions listed in the CSV file, and then uses the `AzManagementPartner` module to link the Service Principal to The Partner's MPN Id to complete the Partner Admin Link.

## Consequences

The Partner has a single identity which they can use to configure PAL against all their customers.
The Customer has a clearly named Service Principal which they control, which signifies Partner Contribution.
The Partner has no access to the necessarily priviliged Service Principal, thus satisfying the Zero Trust requirement.
Microsoft can see the relationship between The Customer and The Partner.