@isTest
private class CreateLeadFromEmailTest {
    static testMethod void testSolarReviewsUtilityCompanyMatch() {
        // Create a new email and envelope object.    
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        String emailText = 'Requested by: John Doe\n';
        emailText += 'johndoe@example.com\n';
        emailText += 'Phone: 5555555555\n;';
        emailText += 'johndoe@example.com\n';
        emailText += 'Phone: 5555555555\n';
        emailText += 'Address of site: 123 Main St\n';
        emailText += 'Anywhere CA 12345\n';
        emailText += 'Electric Spend: 100 per month\n';
        emailText += 'Utility Company: Test\n';
        emailText += 'Additional information: System Size (Kw): 7.76\n';
        emailText += 'Roof Type: Shingles\n';
        emailText += 'Roof Pitch: Slight\n';
        emailText += 'Shading: Shaded (can improve)\n';
        emailText += 'Credit Score: Over 680 Estimate';
        // create test utility company
        Account utilityCompany = new Account();
        utilityCompany.Name = 'Test';
        Id RecordTypeIdUtilityCompany = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Utility Company').getRecordTypeId(); 
        utilityCompany.RecordTypeId = RecordTypeIdUtilityCompany;
        System.debug('Utility Record Type Id = ' + RecordTypeIdUtilityCompany);
        insert utilityCompany;
       

        email.plainTextBody = emailText;
        
        email.Subject = 'Solar-Estimate.org';
        env.fromAddress = 'alaric.wimer@parquetmarketing.com';
        // add a binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my binary attachment text');
        attachment.fileName = 'textfile1.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        // add a text attachment
        Messaging.InboundEmail.TextAttachment attachment2 = new Messaging.InboundEmail.TextAttachment();
        attachment2.body = 'my text attachment text';
        attachment2.fileName = 'textfile2.txt';
        attachment2.mimeTypeSubType = 'text/plain';
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { attachment2 };
        // call the email service class
        CreateLeadFromEmail obj = new CreateLeadFromEmail();
        obj.handleInboundEmail(email, env );
        // get new Lead
        List<Lead> myLead = [
           SELECT Id, Utility_Company__c
             FROM Lead
            WHERE FirstName = 'John'
              AND LastName = 'Doe'
              AND Email = 'johndoe@example.com'
              AND Phone = '5555555555'
              AND Project_Address__c = '123 Main St'
              AND Project_City__c = 'Anywhere'
              AND Project_State__c = 'CA'
              AND Project_Zip_Code__c = '12345'
              AND LeadSource = 'Solar Reviews'
        ];
        System.AssertEquals(myLead.isEmpty(), false);
        System.AssertEquals(myLead.get(0).Utility_Company__c, utilityCompany.Id);
        
        // find the attachment
  		List<Attachment> a = [select name from attachment where parentId = :myLead.get(0).id];
  		System.assertEquals(a.size(), 2);
    } 
    static testMethod void testSolarReviewsUtilityCompanyNoMatch() {
        // Create a new email and envelope object.    
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        String emailText = 'Requested by: John Doe\n';
        emailText += 'johndoe@example.com\n';
        emailText += 'Phone: 5555555555\n;';
        emailText += 'johndoe@example.com\n';
        emailText += 'Phone: 5555555555\n';
        emailText += 'Address of site: 123 Main St\n';
        emailText += 'Anywhere CA 12345\n';
        emailText += 'Electric Spend: 100 per month\n';
        emailText += 'Utility Company: PacificCorp\n';
        emailText += 'Additional information: System Size (Kw): 7.76\n';
        emailText += 'Roof Type: Shingles\n';
        emailText += 'Roof Pitch: Slight\n';
        emailText += 'Shading: Shaded (can improve)\n';
        emailText += 'Credit Score: Over 680 Estimate';
        // create test utility company
        Account utilityCompany = new Account();
        utilityCompany.Name = 'Test';
        Id RecordTypeIdUtilityCompany = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Utility Company').getRecordTypeId(); 
        utilityCompany.RecordTypeId = RecordTypeIdUtilityCompany;
        System.debug('Utility Record Type Id = ' + RecordTypeIdUtilityCompany);
        insert utilityCompany;

        email.plainTextBody = emailText;
        
        email.Subject = 'Solar-Estimate.org';
        env.fromAddress = 'alaric.wimer@parquetmarketing.com';
        // add a binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my binary attachment text');
        attachment.fileName = 'textfile1.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        // add a text attachment
        Messaging.InboundEmail.TextAttachment attachment2 = new Messaging.InboundEmail.TextAttachment();
        attachment2.body = 'my text attachment text';
        attachment2.fileName = 'textfile2.txt';
        attachment2.mimeTypeSubType = 'text/plain';
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { attachment2 };
        // call the email service class
        CreateLeadFromEmail obj = new CreateLeadFromEmail();
        obj.handleInboundEmail(email, env );
        // get new Lead
        List<Lead> myLead = [
            SELECT Id, Utility_Company__c
            FROM Lead
            WHERE FirstName = 'John'
              AND LastName = 'Doe'
              AND Email = 'johndoe@example.com'
              AND Phone = '5555555555'
              AND Project_Address__c = '123 Main St'
              AND Project_City__c = 'Anywhere'
              AND Project_State__c = 'CA'
              AND Project_Zip_Code__c = '12345'
              AND LeadSource = 'Solar Reviews'
        ];
        List<Account> myLeadUc = [SELECT Id, RecordTypeId FROM Account WHERE Name = 'PacificCorp'];
        System.AssertEquals(myLead.isEmpty(), false);
        System.AssertEquals(myLead.get(0).Utility_Company__c, myLeadUc.get(0).Id);
        System.AssertEquals(myLeadUc.get(0).RecordTypeId, RecordTypeIdUtilityCompany);
        // find the attachment
  		List<Attachment> a = [select name from attachment where parentId = :myLead.get(0).id];
  		System.assertEquals(a.size(), 2);
        
    }  
    static testMethod void testHomeAdvisor() {
        // Create a new email and envelope object.    
        
        Messaging.InboundEmail email  = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        String emailText;
        emailText += 'Install Solar Panels For Electric System\n';
        emailText += 'Customer Information\n';
        emailText += 'Michael Eannelli\n';
        emailText += '[image: Phone] (608) 888-2833 <//6088882833> ext 1111\n';
        emailText += '[image: Phone] (608) 469-9142 <//6084699142>\n';
        emailText += '[image: Message] Send a Message\n';
        emailText += '<https://pro.homeadvisor.com/channel?consumerId=47535910&leadId=358610753&template_id=112&todo_id=2852075899&entry_point_id=33031415&entityID=84999490&comm_auth_dt=201909111520&comm_auth_id=homeadv&comm_auth_hash=0e536a02906f02d262f6bd3ec84945e6>\n';
        emailText += '[image: E-mail] eannelli.pharmacy@gmail.com\n';
        emailText += '[image: Address] 4525 Pawnee Pass, Madison, WI 53711\n';
        emailText += '<https://maps.google.com?q=4525+Pawnee+Pass,+Madison,+WI+53711>\n';
        emailText += '[image: View Lead at HomeAdvisor]\n';
        emailText += '<https://pro.homeadvisor.com/leads/pipeline/?template_id=112&todo_id=2852075899&entry_point_id=31597050&entityID=84999490&comm_auth_dt=201909111520&comm_auth_id=homeadv&comm_auth_hash=0e536a02906f02d262f6bd3ec84945e6&leadId=358610753#lead/358610753>\n';
        emailText += 'Job Information\n';
        emailText += 'Property Owner';

        email.plainTextBody = emailText;
        
        email.Subject = 'HomeAdvisor';
        env.fromAddress = 'alaric.wimer@parquetmarketing.com';
        // add a binary attachment
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my binary attachment text');
        attachment.fileName = 'textfile1.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        // add a text attachment
        Messaging.InboundEmail.TextAttachment attachment2 = new Messaging.InboundEmail.TextAttachment();
        attachment2.body = 'my text attachment text';
        attachment2.fileName = 'textfile2.txt';
        attachment2.mimeTypeSubType = 'text/plain';
        email.textAttachments = new Messaging.inboundEmail.TextAttachment[] { attachment2 };
        // call the email service class
        CreateLeadFromEmail obj = new CreateLeadFromEmail();
        obj.handleInboundEmail(email, env );
        // get new Lead
        List<Lead> myLead = [
            SELECT Id
            FROM Lead
            WHERE FirstName = 'Michael'
              AND LastName = 'Eannelli'
              AND Email = 'eannelli.pharmacy@gmail.com'
              AND Phone = '6084699142'
              AND Project_Address__c = '4525 Pawnee Pass'
              AND Project_City__c = 'Madison'
              AND Project_State__c = 'WI'
              AND Project_Zip_Code__c = '53711'
              AND LeadSource = 'Home Advisor'
        ];
        System.AssertEquals(myLead.isEmpty(), false);
        // find the attachment
  		List<Attachment> a = [select name from attachment where parentId = :myLead.get(0).id];
  		System.assertEquals(a.size(), 2);
    }  
}