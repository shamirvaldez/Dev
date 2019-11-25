<#include "BaseIncludesJPOS">
<#assign leftColWidth=10/>
<#assign rightColWidth=11/>
<#assign taxRateColWidth=5/>
<#assign middleColWidth=(maxCharPerLine-leftColWidth-rightColWidth-taxRateColWidth)/>
<#-- Macro/function to print the colums -->
<#macro left_col><@pad_right length=leftColWidth><#nested></@pad_right></#macro>
<#macro middle_col><@pad_right length=middleColWidth><#nested></@pad_right></#macro>
<#macro bigmiddle_col><@pad_right length=(middleColWidth+rightColWidth)><#nested></@pad_right></#macro>
<#macro right_col><@pad_left length=rightColWidth><#nested></@pad_left></#macro>
<#macro tax_col><@pad_left length=taxRateColWidth><#nested></@pad_left></#macro>
<#macro bigleft_col><@pad_right length=(maxCharPerLine / 2)><#nested></@pad_right></#macro>
<#-- Macro/function to print a single payment item -->
<#macro printPaymentItem key paymentItem>
<#-- check if payment item is not 0.00 -->
<#-- status 5 => void, status 4 => invalid -->
<#if paymentItem.businessTransactionAmount != 0 && paymentItem.status != "5" && paymentItem.status != "4">
<#-- if it is paid in a different currency -->
<#assign name><@translate key=key/></#assign>
<#if (paymentItem.originalBusinessTransactioncurrency?? && paymentItem.businessTransactioncurrency != paymentItem.originalBusinessTransactioncurrency)>
<@left_col/>${name} (${paymentItem.originalBusinessTransactioncurrency}):
<@left_col/><@middle_col>  ${paymentItem.originalBusinessTransactionAmount?string(decimal_format)} x ${paymentItem.exchangeRateUsed?string("#,##0.00####")} =</@middle_col><@right_col>${paymentItem.businessTransactionAmount?string(decimal_format)}</@right_col>
<#else>
<@left_col/><@middle_col>${name}:</@middle_col><@right_col>${paymentItem.businessTransactionAmount?string(decimal_format)}</@right_col>
</#if>
<#if (paymentItem.voucher.voucherID)??>
<@left_col/><@middle_col>  ID ${paymentItem.voucher.voucherID}</@middle_col>
</#if>
</#if>
</#macro>
<#macro printSalesItems printOnlyCancellationItems=false>
<#if receipt.salesItems??>
<#list receipt.salesItems as salesItem>
<#if !(printOnlyCancellationItems = true && salesItem.cancellationSalesItem = false)>
<#assign salesItemId=""/>
<#assign taxRateCode=""/>
<#-- Assign the variables -->
<#-- Material -->
<#if salesItem.typeCode = "1" && salesItem.material??>
<#-- check if it is a cancellation sales item -->
<#if salesItem.cancellationSalesItem = true && salesItem.referenceSalesItem??>
<#assign salesItemId><#if (salesItem.referenceSalesItem.material.externalID)??>${salesItem.referenceSalesItem.material.externalID}<#else>-</#if></#assign>
<#assign taxRateCode><#if (salesItem.referenceSalesItem.taxRateTypeCode)??>${salesItem.referenceSalesItem.taxRateTypeCode}<#else>-</#if></#assign>
<#elseif salesItem.material??>
<#assign salesItemId><#if (salesItem.material.externalID)??><@printMaterialExternalID field=salesItem.material.externalID maxLength=leftColWidth/><#else>-</#if></#assign>
<#assign taxRateCode><#if (salesItem.taxRateTypeCode)??>${salesItem.taxRateTypeCode}<#else>-</#if></#assign>
</#if>
<#-- Voucher -->
<#elseif salesItem.typeCode = "2" && salesItem.voucher??>
<#assign salesItemId><#if salesItem.voucher.voucherID??>${salesItem.voucher.voucherID}<#else>-</#if></#assign>
<#-- Special Sales Item -->
<#elseif salesItem.typeCode = "3">
<#assign salesItemId><@translate key="label.special_sales_item_id.special"/></#assign>
<#-- Invoice -->
<#elseif salesItem.typeCode = "6">
<#assign salesItemId><@translate key="label.special_sales_item_id.invoice"/></#assign>
<#-- Down Payment -->
<#elseif salesItem.typeCode = "8">
<#assign salesItemId><@translate key="label.special_sales_item_id.down_payment"/></#assign>
<#-- Sales Set with hideSetComponents = true -->
<#elseif salesItem.typeCode = "12" && (salesItem.material)?? && salesItem.material.hideSetComponents=true>
<#assign salesItemId><#if (salesItem.material.externalID)??>${salesItem.material.externalID}<#else>-</#if></#assign>
<#-- Expense -->
<#elseif salesItem.typeCode = "13">
<#assign salesItemId><@translate key="label.special_sales_item_id.expense"/></#assign>
</#if>
<#-- Print the sales item -->
<#-- Invoice or Down Payment  -->
<#if salesItem.typeCode == "12" && (!(salesItem.material)?? || ((salesItem.material)?? && salesItem.material.hideSetComponents=false))>
<@left_col><#if cashdesk.alwaysPrintShortText?? && cashdesk.alwaysPrintShortText=true && salesItem.material.shortText?? && salesItem.material.shortText!="">${salesItem.material.shortText}<#elseif salesItem.description??>${salesItem.description}</#if></@left_col><@middle_col>${salesItem.quantity} x ${salesItem.unitGrossAmount?string(decimal_format)}</@middle_col><@right_col>${(salesItem.grossAmount - salesItem.discountAmount)?string(decimal_format)}</@right_col>
<#else>
<#if salesItem.typeCode = "6" || salesItem.typeCode = "8">
<@pad_right length=(leftColWidth + middleColWidth + rightColWidth)>${salesItemId}: ${salesItem.id}</@pad_right>
<@left_col/><#else><@left_col>${salesItemId}</@left_col></#if><@middle_col>${salesItem.quantity} <#if salesItem.quantityTypeCodeName??>${salesItem.quantityTypeCodeName} </#if>x ${salesItem.unitGrossAmount?string(decimal_format)}</@middle_col><@right_col>${(salesItem.grossAmount - salesItem.discountAmount)?string(decimal_format)}</@right_col><@tax_col>${salesItem.taxRateTypeCode}</@tax_col>
</#if>
<#-- Check if reserve invoice and different deliverd quantity-->
<#if receipt.typeCode == "12" && salesItem.quantity != salesItem.deliveredQuantity>
<@left_col/><@bigmiddle_col><@translate key="label.delivered"/>: ${salesItem.deliveredQuantity}<#if salesItem.quantityTypeCodeName??> ${salesItem.quantityTypeCodeName}</#if></@bigmiddle_col>
</#if>
<#if (salesItem.typeCode != "12" || (salesItem.typeCode = "12" && salesItem.description?? && (salesItem.material)?? && salesItem.material.hideSetComponents=true)) && cashdesk.alwaysPrintShortText?? && cashdesk.alwaysPrintShortText=true && (salesItem.material.shortText)?? && salesItem.material.shortText!="">
<@left_col/><@bigmiddle_col>${salesItem.material.shortText}</@bigmiddle_col>
<#elseif (salesItem.typeCode != "12" || (salesItem.typeCode = "12" && salesItem.description?? && (salesItem.material)?? && salesItem.material.hideSetComponents=true)) && salesItem.description??>
<@left_col/><@bigmiddle_col>${salesItem.description}</@bigmiddle_col>
</#if>
<#-- Check if a reference to a sales order exists -->
<#if salesItem.erpSalesBusinessObjectId?? && salesItem.erpSalesBusinessObjectPosition?? && salesItem.erpSalesBusinessObjectType??>
<@left_col/><@bigmiddle_col><@translate key=salesItem.erpSalesBusinessObjectType/>: ${salesItem.erpSalesBusinessObjectId}/${salesItem.erpSalesBusinessObjectPosition}</@bigmiddle_col>
</#if>
<@printBatchNumber salesItem=salesItem/>
<#-- Check for discount -->
<#if salesItem.discountAmount?? && (salesItem.discountAmount != 0)>
<@left_col/><@bigmiddle_col><@translate key="label.discount"/>: ${salesItem.discountAmount?string(decimal_format)} ${receipt.currency} (${salesItem.discountPercentage?string(decimal_format)}%)</@bigmiddle_col>
</#if>
<#if (salesItem.salesPerson.formattedNameSalesPersonStyle)?? && salesItem.salesPerson.formattedNameSalesPersonStyle != "">
<@left_col/><@bigmiddle_col><@translate key="label.salesperson"/>: ${salesItem.salesPerson.formattedNameSalesPersonStyle}</@bigmiddle_col>
</#if>
<#-- print manual set subItems -->
<#if salesItem.typeCode == "12" && (!(salesItem.material)?? || ((salesItem.material)?? && salesItem.material.hideSetComponents=false))>
<@printSubItems salesItem=salesItem/>
</#if>
<#if cashdesk.printReceiptIdForReturnItems?? && cashdesk.printReceiptIdForReturnItems=true && salesItem.cancellationSalesItem=true  && salesItem.referenceSalesItemReceiptId?? && salesItem.referenceSalesItemReceiptId != "">
<@left_col/><@bigmiddle_col><@translate key="label.referenceSalesItem.ReceiptId"/>: ${salesItem.referenceSalesItemReceiptId}</@bigmiddle_col>
</#if>
</#if>
</#list>
</#if>
</#macro>
<#macro printSubItems salesItem>
<#list salesItem.subItems  as subItem>
<#-- uncomment the next line, to show the quantity and quantityTypeCodeName -->
<#-- <@left_col/><@middle_col>  ${subItem.quantity} <#if subItem.quantityTypeCodeName??>${subItem.quantityTypeCodeName} </#if>x ${subItem.unitGrossAmount?string(decimal_format)}</@middle_col><@right_col/> -->
<@left_col> <@printMaterialExternalID field=subItem.material.externalID maxLength=leftColWidth-1/></@left_col><@middle_col>${subItem.quantity} x <#if cashdesk.alwaysPrintShortText?? && cashdesk.alwaysPrintShortText=true && subItem.material.shortText?? && subItem.material.shortText!="">${subItem.material.shortText}<#else>${subItem.description}</#if></@middle_col><@right_col>(${(subItem.grossAmount - subItem.discountAmount)?string(decimal_format)})</@right_col><@tax_col>${subItem.taxRateTypeCode}</@tax_col>
<@printBatchNumber salesItem=subItem/>
</#list>
</#macro>
<#macro printBatchNumber salesItem>
<#-- Managed by BATCH_NUMBER -->
<#if salesItem.managedByNumber?? && (salesItem.managedByNumber!?length > 0)>
<#if salesItem.managedBy = "3">
<@left_col/><@bigmiddle_col><@translate key="label.sales_item_managed_by.batch_no"/>: ${salesItem.managedByNumber}</@bigmiddle_col>
<#-- Managed by SERIAL_NUMBER -->
<#elseif salesItem.managedBy = "2">
<@left_col/><@bigmiddle_col><@translate key="label.sales_item_managed_by.serial_no"/>: ${salesItem.managedByNumber}</@bigmiddle_col>
</#if>
</#if>
</#macro>
<#-- Print the header -->
<#include "HeaderTemplateJPOS">
<#if isReprint = true>
<@reverse><@center><@translate key="label.reprint"/></@center></@reverse>
<@lf/>
</#if>
<#if isMerchantCopy = true>
<@reverse><@center><@translate key="label.merchant_copy"/></@center></@reverse>
<@lf/>
</#if>
<#-- Status parked -->
<#if receipt.status = "4">
<@reverse><@center><@translate key="label.parked"/></@center></@reverse>
<@lf/>
<#-- Status void -->
<#elseif receipt.status = "6">
<#if (rksvPlugin?? && (rksvPlugin.receiptType) != "normal")>

<#else>
<@reverse><@center><@translate key="label.cancellation"/></@center></@reverse>
</#if>
<#-- preliminary print -->
<#elseif receipt.status = "1">
<@reverse><@center><@translate key="label.preliminary"/></@center></@reverse>
<@lf/>
</#if>
<#-- check if return receipt  -->
<#if receipt.cancellationStatus="1" && receipt.containsOnlyCancellationSalesItem = true>
<@wide><@high><@center><@translate key="label.return"/></@center></@high></@wide>
<@lf/>
<@left_col><@translate key="label.return.id"/>:</@left_col>${receipt.receiptID}
<#else>
<#if (rksvPlugin?? && (rksvPlugin.receiptType) = "annual")>
<@wide><@high><@center><@translate key="label.rksv.annualreceipt"/></@center></@high></@wide>
<#elseif (rksvPlugin?? && (rksvPlugin.receiptType) = "initial")>
<@wide><@high><@center><@translate key="label.rksv.initialreceipt"/></@center></@high></@wide>
<#elseif (rksvPlugin?? && (rksvPlugin.receiptType) = "null")>
<@wide><@high><@center><@translate key="label.rksv.nullreceipt"/></@center></@high></@wide>
<#elseif receipt.classification?? && receipt.classification.name() = "BILL">
<@wide><@high><@center><@translate key="label.bill"/></@center></@high></@wide>
<#elseif receipt.classification?? && receipt.classification.name() = "PROOF_OF_PAYMENT">
<@wide><@high><@center><@translate key="label.proof_of_payment"/></@center></@high></@wide>
<#elseif receipt.classification?? && receipt.classification.name() = "TICKET">
<@wide><@high><@center><@translate key="label.receipt"/></@center></@high></@wide>
<#elseif receipt.classification?? && receipt.classification.name() = "INVOICE">
<@wide><@high><@center><@translate key="label.invoice"/></@center></@high></@wide>
<#else>
<@wide><@high><@center><@translate key="label.receipt"/></@center></@high></@wide>
</#if>
<@lf/>
<@left_col><@translate key="label.receipt.id"/>:</@left_col>${receipt.receiptID}</#if><#if (TIPO_NCF)??>
<@left_col>Tipo NCF:</@left_col>${TIPO_NCF}</#if><#if (RNC)??>
<@left_col>RNC:</@left_col>${RNC}</#if><#if (NCF)??>
<@left_col>NCF:</@left_col>${NCF}</#if><#if (NCF_NC)??>
<@left_col>NCF mod.:</@left_col>${NCF_NC}</#if>
<#if (receipt.concessionTable.id)??>
<@left_col><@translate key="label.table"/>:</@left_col>${receipt.concessionTable.id} / ${receipt.concessionTableIndex}</#if>
<@left_col><@translate key="label.date"/>:</@left_col>${receipt.businessTransactionDate?datetime}
<#if cashdesk.printPosId>
<@left_col><@translate key="label.pos.system"/>:</@left_col><@bigmiddle_col>${cashdesk.posId}<#if cashdesk.posGroup??> (${cashdesk.posGroup})</#if></@bigmiddle_col>
</#if>
<#if (rksvPlugin??)>
<@left_col><@translate key="label.rksv.cashdeskid"/>:</@left_col>${rksvPlugin.cashDeskId}
</#if>
<#-- only if customerData is set -->
<#if receipt.customerData?? && cashdesk.printBusinessPartnerOnReceipt>
<#if receipt.customerData.customerID?? && receipt.customerData.customerID != "">
<@left_col><@translate key="label.customer"/>:</@left_col>${receipt.customerData.customerID}
</#if>
<#-- Person -->
<#if receipt.customerData.categoryCode = "1">
<@left_col/><@pad_right length=(maxCharPerLine-leftColWidth)><#if receipt.customerData.firstName??>${receipt.customerData.firstName}</#if> <#if receipt.customerData.lastName??>${receipt.customerData.lastName}</#if></@pad_right>
<#-- Organisation -->
<#elseif receipt.customerData.categoryCode = "2">
<@left_col/><@pad_right length=(maxCharPerLine-leftColWidth)><#if receipt.customerData.companyName??>${receipt.customerData.companyName}</#if></@pad_right>
</#if>
<#if receipt.customerData.addressName2?? && receipt.customerData.addressName2 != "">
<@left_col/><@pad_right length=(maxCharPerLine-leftColWidth)>${receipt.customerData.addressName2}</@pad_right>
</#if>
<#if receipt.customerData.addressName3?? && receipt.customerData.addressName3 != "">
<@left_col/><@pad_right length=(maxCharPerLine-leftColWidth)>${receipt.customerData.addressName3}</@pad_right>
</#if>
<#if receipt.customerData.street??>
<@left_col/><@pad_right length=(maxCharPerLine-leftColWidth)>${receipt.customerData.street} <#if receipt.customerData.houseNumber??>${receipt.customerData.houseNumber}</#if></@pad_right>
</#if>
<#if receipt.customerData.postalCode?? || receipt.customerData.city??>
<@left_col/><@pad_right length=(maxCharPerLine-leftColWidth)><#if receipt.customerData.postalCode??>${receipt.customerData.postalCode} </#if><#if receipt.customerData.city??>${receipt.customerData.city}</#if></@pad_right>
</#if>
<#if receipt.customerData.countryCode??>
<@left_col/><@pad_right length=(maxCharPerLine-leftColWidth)>${receipt.customerData.countryCode}</@pad_right>
</#if>
</#if>
<@broken_line/>
<#if receipt.productive?? && receipt.productive != true>
<@wide><@high><@center><@translate key="label.testMode"/></@center></@high></@wide>
</#if>
<#if receipt.status = "1" || (receipt.productive?? && receipt.productive != true)>
<@bold><@center><@translate key="label.noValidTaxDocument"/></@center></@bold>
<@broken_line/>
</#if>
<@left_col/><@middle_col/><@right_col>${receipt.currency}</@right_col>
<#-- The list of sales items -->
<@printSalesItems/>
<@lf/>
<#-- Tax and amount section -->
<#if (receipt.discountAmount?? && (receipt.discountAmount != 0)) || (receipt.paymentGrossAmount != receipt.notRoundedPaymentGrossAmount) || (cashdesk.tipMode = 2)>
<@left_col/><@bold><@middle_col><@translate key="label.receipt.subtotal"/>:</@middle_col><@right_col>${(receipt.paymentSubTotal)?string(decimal_format)}</@right_col></@bold>
</#if>
<#-- Print discount if available -->
<#if receipt.discountAmount?? && (receipt.discountAmount != 0)>
<@left_col/><@middle_col><@translate key="label.receipt.discount"/>: ${receipt.discountPercentage?string(decimal_format)}%</@middle_col>
<@left_col/><@middle_col><@translate key="label.of"/> ${receipt.discountablePaymentGrossAmount?string(decimal_format)} ${receipt.currency} =</@middle_col><@right_col>${(-receipt.discountAmount)?string(decimal_format)}</@right_col>
</#if>
<#if receipt.loyaltyPayments??>
<#list receipt.loyaltyPayments as loyaltyPayment>
<@left_col/><@middle_col><@translate key="label.receipt.loyalty.discount"/> </@middle_col>
<@left_col/><@middle_col>${loyaltyPayment.pointValue?string(decimal_format)} Pts.</@middle_col><@right_col>${(-loyaltyPayment.amount)?string(decimal_format)}</@right_col>
</#list>
</#if>
<#if (receipt.paymentGrossAmount != receipt.notRoundedPaymentGrossAmount)>
<@left_col/><@middle_col><@translate key="label.receipt.rounding"/>:</@middle_col><@right_col>${(receipt.paymentGrossAmount - receipt.notRoundedPaymentGrossAmount)?string(decimal_format)}</@right_col>
</#if>
<#if cashdesk.tipMode = 2>
<@left_col/><@middle_col><@translate key="label.tip"/>:</@middle_col><@right_col>${receipt.tip?string(decimal_format)}</@right_col>
</#if>
<@pad_left length=leftColWidth></@pad_left><@high><@middle_col><@translate key="label.receipt.total"/>:</@middle_col><@right_col>${receipt.paymentGrossAmount?string(decimal_format)}</@right_col></@high>
<#if !receipt.classification?? || receipt.classification.name() != "PROOF_OF_PAYMENT">
<@left_col/><@middle_col><@translate key="label.receipt.net_amount"/>:</@middle_col><@right_col>${receipt.paymentNetAmount?string(decimal_format)}</@right_col>
<#-- Tax -->
<@left_col/><@middle_col><@translate key="label.tax.amounts"/>:</@middle_col>
<#if receipt.taxItems??>
<#list receipt.taxItems as taxItem>
<#if taxItem.taxRate??>
<#assign taxRateDescription>${(taxItem.taxRate * 100)?string(decimal_format)}%</#assign>
<#else>
<#assign taxRateDescription>${taxItem.description}</#assign>
</#if>
<@left_col/><@middle_col>${taxItem.taxRateTypeCode}: ${taxRateDescription}</@middle_col><@right_col>${taxItem.businessTransactionAmount?string(decimal_format)}</@right_col>
</#list>
</#if>
</#if>
<#-- Tip -->
<#if cashdesk.tipMode = 1>
<@lf/>
<@left_col/><@bold><@middle_col><@translate key="label.tip"/>:</@middle_col></@bold><@right_col>__________</@right_col>
</#if>
<@lf/>
<#-- Debtor Item -->
<#if (receipt.debtorItem.businessTransactionAmount)??>
<#if (receipt.debtorItem.businessTransactionAmount >= 0)>
<@left_col/><@middle_col><@translate key="label.payment.invoice"/>: </@middle_col><@right_col>${receipt.debtorItem.businessTransactionAmount?string(decimal_format)}</@right_col><#if (receipt.debtorItem.note)??>
<@left_col/><@bold><@bigmiddle_col>${receipt.debtorItem.note}</@bigmiddle_col></@bold></#if>
<#else>
<@left_col/><@middle_col><@translate key="label.payment.credit"/>: </@middle_col><@right_col>${receipt.debtorItem.businessTransactionAmount?string(decimal_format)}</@right_col>
</#if>
</#if>
<#-- Payment items -->
<#if receipt.paymentItems??>
<#list receipt.paymentItems as paymentItem>
<#if (paymentItem.roundingAmount)?? && (paymentItem.roundingAmount != 0)>
<#assign paymentRounding=paymentItem.roundingAmount/>
</#if>
<#-- Cash -->
<#if (paymentItem.paymentFormCode = "09")>
<#if (paymentItem.businessTransactionAmount >= 0)>
<@printPaymentItem key="label.payment.cash" paymentItem=paymentItem/>
<#else>
<#-- drawback amout -->
<@printPaymentItem key="label.payment.drawback" paymentItem=paymentItem/>
</#if>
</#if>
<#-- Card -->
<#if (paymentItem.paymentFormCode = "02")>
<#if paymentItem.creditCardTypeName??>
<#assign creditCardName>${paymentItem.creditCardTypeName}</#assign>
<#else>
<#assign creditCardName><@translate key="label.payment.card.unknown"/></#assign>
</#if>
<@printPaymentItem key=creditCardName paymentItem=paymentItem/>
</#if>
<#-- Bank transfer -->
<#if (paymentItem.paymentFormCode = "05")>
<@printPaymentItem key="label.payment.transfer" paymentItem=paymentItem/>
</#if>
<#-- Check -->
<#if (paymentItem.paymentFormCode = "06")>
<@printPaymentItem key="label.payment.cheque" paymentItem=paymentItem/>
</#if>
<#-- Voucher -->
<#if (paymentItem.paymentFormCode = "20")>
<@printPaymentItem key="label.payment.voucher" paymentItem=paymentItem/>
</#if>
</#list>
</#if>
<#if paymentRounding??>
<@left_col/><@middle_col><@translate key="label.receipt.rounding"/>:</@middle_col><@right_col>${paymentRounding?string(decimal_format)}</@right_col>
</#if>
<@lf/>
<#if (receipt.salesPerson.formattedNameSalesPersonStyle)?? && receipt.salesPerson.formattedNameSalesPersonStyle != "">
<@pad_right><@translate key="label.salesperson"/>: ${receipt.salesPerson.formattedNameSalesPersonStyle}</@pad_right>
</#if>
<#if (user.formattedNameCashierStyle)?? && user.formattedNameCashierStyle != "">
<@pad_right><@translate key="label.served_by"/>: ${user.formattedNameCashierStyle}</@pad_right>
</#if>
<#if receipt.debtorItem??>
<@lf repeat=6/>
<@broken_line/>
<@pad_right><@center><@translate key="label.signature.customer"/></@center></@pad_right>
<@lf/>
</#if>
<#if terminalCustomerLines?? && isMerchantCopy = false>
<@solid_line/>
<@lf/>
<#list terminalCustomerLines as terminalCustomerLine>
${terminalCustomerLine}
</#list>
</#if>
<#if (rksvPlugin??)>
<#if ((rksvPlugin.directPrintOutput) = false && (rksvPlugin.qrCodePath)??)>
<@image name=rksvPlugin.qrCodePath baseDir=rksvPlugin.imageDirectory/>
<#else>
<#list rksvPlugin.directPrintOutputText as outputText>
     ${outputText}
</#list>
</#if>
<#if ((rksvPlugin.signatureFailure) = true)>
<@center> ${rksvPlugin.signatureFailureText} </@center>
</#if>
</#if>
<#if cashdesk.printBarcode?? && cashdesk.printBarcode = true>
<@solid_line/>
<@lf/>
<@barcode value=receipt.receiptID/>
</#if>
<#if receipt.loyaltyAccount?? && receipt.status != "6">
<@solid_line/>
<@lf/>
<@wide><@high><@center><@translate key="label.loyalty"/></@center></@high></@wide>
<@bigleft_col><@translate key="label.loyaltyAccountId"/>:</@bigleft_col>${receipt.loyaltyAccount.loyaltyAccountId}
<#if receipt.loyaltyAccountTotalPoints??>
<@bigleft_col><@translate key="label.totalLoyaltyPoints"/>:</@bigleft_col>${receipt.loyaltyAccountTotalPoints}
</#if>
<#if receipt.loyaltyPoints??>
<@bigleft_col><@translate key="label.loyaltyPoints"/>:</@bigleft_col>${receipt.loyaltyPoints}
</#if>
</#if>
<#if cashdesk.printEntertainmentExpenses = true && isMerchantCopy = false && (receipt.status = "1" ||receipt.status = "2")>
<#-- Print the receipt for entertainment expenses -->
<@solid_line/>
<@translate key="label.entertainmentexpenses.purpose"/>
<@lf/>
(<@translate key="label.entertainmentexpenses.article"/>)
<@lf/><@lf/>
<@bold><@translate key="label.entertainmentexpenses.guests"/>:</@bold>
<@lf/>
<@broken_line/>
<@lf/>
<@broken_line/>
<@lf/>
<@broken_line/>
<@lf/>
<@broken_line/>
<@lf/>
<@broken_line/>
<@lf/>
<@bold><@translate key="label.entertainmentexpenses.reason"/>:</@bold>
<@lf/>
<@broken_line/>
<@lf/>
<@broken_line/>
<@lf/>
<@broken_line/>
<@lf/>
<@translate key="label.entertainmentexpenses.amount"/>

<@translate key="label.entertainmentexpenses.signature"/>
<@lf repeat=2/>
<@broken_line/>
</#if>
<#-- Print the footer -->
<#include "FooterTemplateJPOS">
<#-- print special receipt for returned items -->
<#if cashdesk.returnProtocolEnabled = true && receipt.containsCancellationSalesItem = true && isMerchantCopy = false && (receipt.status = "1" ||receipt.status = "2")>
<@cut_paper/>
<#-- Print the header -->
<#include "HeaderTemplateJPOS">
<#if isReprint = true>
<@reverse><@center><@translate key="label.reprint"/></@center></@reverse>
<@lf/>
</#if>
<@wide><@high><@center><@translate key="label.return_protocol"/></@center></@high></@wide>
<@lf/>
<@left_col><@translate key="label.receipt.id"/>:</@left_col>${receipt.receiptID}

<#if (user.formattedNameCashierStyle)?? && user.formattedNameCashierStyle != "">
<@left_col><@translate key="label.cashier"/>:</@left_col>${user.formattedNameCashierStyle}
</#if>
<@left_col><@translate key="label.date"/>:</@left_col>${receipt.businessTransactionDate?datetime}
<@broken_line/>
<@left_col/><@middle_col/><@right_col>${receipt.currency}</@right_col>
<@printSalesItems printOnlyCancellationItems=true/>
<@lf repeat=4/>
<@broken_line/>
<@center><@translate key="label.signature.cashier"/>:</@center>
<@lf repeat=4/>
<@broken_line/>
<@center><@translate key="label.customer.name"/></@center>
<@lf repeat=4/>
<@broken_line/>
<@center><@translate key="label.customer.adress"/></@center>
<@lf repeat=4/>
<@broken_line/>
<@center><@translate key="label.signature.customer"/></@center>
<@solid_line/>
<@lf/>
<@barcode value=receipt.receiptID/>
<#-- Print the footer -->
<#include "FooterTemplateJPOS">
</#if>
<#if terminalMerchantLines?? && isMerchantCopy = false>
<@cut_paper/>
<#list terminalMerchantLines as terminalMerchantLine>
${terminalMerchantLine}
</#list>
<@lf repeat=2/>
</#if>

