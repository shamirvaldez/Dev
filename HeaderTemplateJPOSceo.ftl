<#include "BaseIncludesJPOS">
<@lf/>
<#if cashdesk.logoPath??>
<@image name=cashdesk.logoPath/>
</#if>
<#if (cashdesk.description)??>
<@wide><@high>${cashdesk.description}</@high></@wide>
</#if>

<#if (cashdesk.companyName)??>
${cashdesk.companyName}
</#if>
<#if (cashdesk.taxNumber)??>
RNC: ${cashdesk.taxNumber}
</#if>
<#if (cashdesk.street)??>
${cashdesk.street}
</#if>
<#if (cashdesk.phoneNumber)??>
${cashdesk.phoneNumber}
</#if>
<#if (cashdesk.webAddress)??>
${cashdesk.webAddress}
</#if>
<#if (cashdesk.email)??>
${cashdesk.email}
</#if>
<#if (cashdesk.headerTextOnReceipt)??>
<@solid_line/>
<#list cashdesk.headerTextOnReceipt as headerLine><@translate key=headerLine/></#list>

</#if>
<@solid_line/>

