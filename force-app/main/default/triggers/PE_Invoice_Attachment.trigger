trigger PE_Invoice_Attachment on Invoice_Attachment__e (after insert) {
    system.debug('After Insert');
    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('PEInvoiceAttachment');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if (triggerConfig != null && triggerConfig.Trigger_Status__c){
        
        for(Invoice_Attachment__e invoiceAttRec : trigger.newMap.values()){
            system.debug('invoiceAttRec.Invoice__c-->'+invoiceAttRec.Invoice__c);
            RetailInvoiceHelper.attachPdf(invoiceAttRec.Invoice__c);
        }
    }
}