public class ReceiptTriggerHelper {
    static ReceiptTriggerHelper handlerInstance;
    
    public static ReceiptTriggerHelper getInstance(){
        if (handlerInstance == null)
            handlerInstance = new ReceiptTriggerHelper();
        return handlerInstance;
    }
    public void afterUpdate(Map<Id, Receipt__c> newMap, Map<Id,Receipt__c> oldmap){
        system.debug('Receipt Helper after update');
        set<Id> receiptIds = new Set<Id>();
        set<Id> secondReceiptId = new set<Id>();
        List<Receipt__c> updateReceiptsList = new List<Receipt__c>();
        List<Invoice__c> invoiceRecordsToUpdate = new List<Invoice__c>();
        
        for(Receipt__c receiptRecord : newMap.values()){
            if(receiptRecord.Receipt_Status__c != oldmap.get(receiptRecord.Id).Receipt_Status__c && receiptRecord.Receipt_Status__c != null && receiptRecord.Receipt_Status__c == 'Received/Paid' && receiptRecord.Is_Pending_Receipt__c == false ){
                system.debug('Receipt status is updated as Received -- '+receiptIds);
                receiptIds.add(receiptRecord.Id);
            }
            if(receiptRecord.Receipt_Status__c != oldmap.get(receiptRecord.Id).Receipt_Status__c && receiptRecord.Receipt_Status__c != null && receiptRecord.Receipt_Status__c == 'Received/Paid' && receiptRecord.Is_Pending_Receipt__c == true ){
                system.debug('Receipt status is updated as Received -- '+receiptIds);
                secondReceiptId.add(receiptRecord.Id);
            }
        }
        system.debug('receiptIds--->'+receiptIds);
        if(!receiptIds.isEmpty()){
            system.debug('Calling Receipt PDf');
            Invoice_Receipt_PDF_Controller.attachReceiptUnderRecord(receiptIds);
        }
         if(!secondReceiptId.isEmpty()){
            system.debug('Calling Receipt PDf');
            Invoice_Receipt_PDF_Controller.attachSecondReceiptUnderRecord(secondReceiptId);
        }
        
    }
     public void handleSecondReceipt(Map<Id, Receipt__c> newMap, Map<Id,Receipt__c> oldmap){
        system.debug('Receipt Helper before update');
         Set<id> invoiceIds = new Set<Id>();
         List<Invoice__c> invoiceList = new List<Invoice__c>();
         List<Receipt__c> receiptListToUpdate = new List<Receipt__C>();
         
         for(Receipt__c receiptRecord : newMap.values()){
             if(receiptRecord.Receipt_Status__c != oldmap.get(receiptRecord.Id).Receipt_Status__c && receiptRecord.Receipt_Status__c != null && receiptRecord.Receipt_Status__c == 'Received/Paid' && receiptRecord.Invoice_Type__c == 'Loan'){
                 invoiceIds.add(receiptRecord.Invoice__c);
             }
         }
         if(!invoiceIds.isEmpty()){
             invoiceList = [Select id,(Select Id,Is_Pending_Receipt__c,Receipt_Status__c From Receipts__r where Receipt_Status__c != 'Received/Paid') From Invoice__c where Id in: invoiceIds];
             if(!invoiceList.isEmpty()){
                 for(Invoice__c invoiceRec : invoiceList){
                     if(!invoiceRec.Receipts__r.isEmpty()){
                         for(Receipt__c receiptRec : invoiceRec.Receipts__r){
                             Receipt__c receiptRecToUpdate = new Receipt__c();
                             receiptRecToUpdate.Id = receiptRec.Id;
                             receiptRecToUpdate.Is_Pending_Receipt__c = true;
                             receiptListToUpdate.add(receiptRecToUpdate);
                         }
                     }
                 }
                 if(!receiptListToUpdate.isEmpty()){
                     update receiptListToUpdate;
                 }
             }
         }
    }
}