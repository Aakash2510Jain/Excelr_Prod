public with sharing class Invoice_Receipt_PDF_Controller {
    public Invoice__c invoiceRec {get; set;} 
    public List<Receipt__c> receiptRec {get; set;} 
    public List<OpportunityLineItem> productname {get; set;} 

    public string studentname {get; set;} 
    public string phone {get; set;} 
    public string email {get; set;} 
    public string receiptNumber {get; set;} 
    public string invoiceNo {get; set;} 
    public string proname {get; set;} 
    public Decimal amount {get; set;} 
    public Decimal downpayment {get; set;} 
    public Decimal dueAmount {get; set;}
    public string  amountinwords {get; set;}
   
    
    


    public Invoice_Receipt_PDF_Controller(ApexPages.StandardController ctrl) {
        try{
            id invoiceId =  ApexPages.currentPage().getParameters().get('Id'); 
            
            invoiceRec = [Select Name,Initiated_Date__c,Down_Payment__c,Opportunity__c,Opportunity__r.Amount,  Opportunity__r.Name, Opportunity__r.Phone__c, Opportunity__r.Account.Email__c FROM Invoice__c where Id =: invoiceId limit 1] ;
           studentname = invoiceRec.Opportunity__r.Name ;
           phone = invoiceRec.Opportunity__r.Phone__c ;
           email = invoiceRec.Opportunity__r.Email__c ;
           amount = invoiceRec.Opportunity__r.Amount;
           amountinwords = ConvertNumberInToWords.english_number(amount);
           downpayment = invoiceRec.Down_Payment__c;
              dueAmount = amount - downpayment;
             invoiceNo = invoiceRec.Name;

            
            // receiptNo = invoiceRec.
            // invoicedate  = invoiceRec
           id  oppid = invoiceRec.Opportunity__c;
             string proname;
            productname = [Select Name From OpportunityLineItem where  OpportunityId =: oppid ];

            for( OpportunityLineItem   oliRec : productname){
                proname = oliRec.Name;
            }

            string  receiptNumber;

            receiptRec = [Select Name,Amount__c,Invoice__r.Name From  Receipt__c where Invoice__c =: invoiceId];
            for(Receipt__c receiptlist : receiptRec){
               receiptNumber = receiptlist.Name;

            }
            

         } catch(Exception e){
             System.debug('Error--'+e.getMessage() +' Line No ::'+e.getLineNumber());
         } 
 
     }
 
 }