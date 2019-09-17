// /**
//  * Email services are automated processes that use Apex classes
//  * to process the contents, headers, and attachments of inbound
//  * email.
//  */
/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class CreateLeadFromEmail implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

		String subToCompareOne = 'HomeAdvisor';
		String subToCompareTwo = 'Solar-Estimate.org';
        String emailText       = email.plainTextBody;
        System.debug(emailText);

		if (email.subject.contains(subToCompareOne) || email.subject.contains(subToCompareTwo)) {
            Lead newLead = new Lead();
            if (email.subject.contains(subToCompareOne)) { // iF HOMEADVISOR EMAIL
                List<String> lstLines = new List<String>();
                List<String> leadInfoList  = new List<String>();
                lstLines = emailText.split('\n');
                String temp;
                Integer startIndex;
                Integer endIndex;
                System.debug(lstLines);
                // Extract relevant information from the email text
                for (Integer i = 0; i < lstLines.size(); i++) {
                    if (lstLines.get(i).contains('Customer Information')) { // start of relevant info
                        startIndex = i;
                    } else if (lstLines.get(i).contains('Property Owner')) { // end of relevant info
                        endIndex = i;
                    }
                }
                // create new list of just the relevant info
                for (Integer i = startIndex; i < endIndex + 1; i++) {
                    leadInfoList.add(lstLines.get(i));
                }

                // use releavant info to set lead field values
                for (Integer i = 0; i < leadinfoList.size(); i++) {
                    if(leadInfolist.get(i).contains('Customer Information')){
                        temp = leadInfoList.get(i+1);
                        String fullName = temp.trim();
                        String fName    = fullName.substring(0, fullName.indexOf(' '));
                        String lName    = fullName.substring(fullName.indexOf(' '));
                        newLead.FirstName = fName;
                        newLead.LastName  = lName;
                        newLead.Company   = fullName;
                    } else if (leadInfoList.get(i).contains('@') && leadInfoList.get(i).contains('.')) {
                        newLead.Email = leadInfoList.get(i).trim();
                    } else  if (leadInfoList.get(i).contains('Phone')) {
                        temp = leadInfoList.get(i).substringAfter('Phone');
                        newLead.Phone = temp.trim();
                    } else if (leadInfoList.get(i).contains('Address')) {
                        temp = leadInfoList.get(i).substringAfter('Address');
                        newLead.Phone = temp.trim();
                    }
                 } // end loop
                    newLead.SDR__c    = 'Casey Creech';
                    insert newLead;
                    System.debug('New Lead inserted: ' + newLead.Firstname + ' ' + newLead.LastName);
            	} // END HOMEADVISOR EMAIL LOGIC
                else if (email.subject.contains(subToCompareTwo)) { // IF SOLAR REVIEWS EMAIL
                List<String> lstLines = new List<String>();
                List<String> leadInfoList  = new List<String>();
                lstLines = emailText.split('\n');
                String temp;
                Integer startIndex;
                Integer endIndex;
                System.debug(lstLines);
                // Extract relevant information from the email text
                for (Integer i = 0; i < lstLines.size(); i++) {
                    if (lstLines.get(i).contains('Requested by')) { // start of relevant info
                        startIndex = i;
                    } else if (lstLines.get(i).contains('Address of site')) { // end of relevant info
                        endIndex = i;
                    }
                }
                // create new list of just the relevant info
                for (Integer i = startIndex; i < endIndex + 1; i++) {
                    leadInfoList.add(lstLines.get(i));
                }
                
                System.debug(leadInfoList);
                
                // use releavnt info to set lead field values
                for (String line: leadInfoList) {
                    if(line.contains('Requested by:')){
                        temp = line.substringAfter('Requested by:');
                        String fullName = temp.trim();
                        String fName    = fullName.substring(0, fullName.indexOf(' '));
                        String lName    = fullName.substring(fullName.indexOf(' '));
                        newLead.FirstName = fName;
                        newLead.LastName  = lName;
                        newLead.Company   = fullName;
                    } else if (line.contains('@') && line.contains('.')) {
                        newLead.Email = line.trim();
                    } else  if (line.contains('Phone:')) {
                        temp = line.substringAfter('Phone:');
                        newLead.Phone = temp.trim();
                    } else if (line.contains('Address')) {
                        temp = line.substringAfter('Address of site:');
                        newLead.Phone = temp.trim();
                    }
                 } // end loop
                    newLead.SDR__c    = 'Casey Creech';
                    insert newLead;
                    System.debug('New Lead inserted: ' + newLead.Firstname + ' ' + newLead.LastName);
            	} // END SOLAR REVIEWS EMAIL LOGIC

            // Save attachments, if any
            if (email.textAttachments != null && email.textAttachments.size() > 0) {
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name       = tAttachment.fileName;
                    attachment.Body       = Blob.valueOf(tAttachment.body);
                    attachment.ParentId   = newLead.Id;
                    insert attachment;
                }
            }
        	// Save any Binary Attachment
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name       = bAttachment.fileName;
                    attachment.Body       = bAttachment.body;
                    attachment.ParentId   = newLead.Id;
                    insert attachment;
                }
            }
           
		}
            result.success = true;
            return result; 
        }
}
// global class CreateLeadFromEmail implements Messaging.InboundEmailHandler {

//     global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

//         Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

// 		String subToCompareOne = 'HomeAdvisor';
// 		String subToCompareTwo = 'Solar-Estimate.org';
//         String emailText       = email.plainTextBody;
//         System.debug(emailText);

// 		if (email.subject.contains(subToCompareOne) || email.subject.contains(subToCompareTwo)) {
//             if (email.subject.contains(subToCompareOne)) { // iF HOMEADVISOR EMAIL
//                 Lead newLead      = new Lead();
//                 // newLead.LastName  = email.fromName.substring(0, email.fromName.indexOf(' '));
//                 // newLead.FirstName = email.fromName.substring(email.fromName.indexOf(' '));
//                 // Get first and last name
//                 String fullName = emailText.substringBetween('Information', '[image:');
//                 String fName    = fullName.substring(0, fullName.indexOf(' '));
//                 String lName    = fullName.substring(fullName.indexOf(' '));
//                 System.debug('first name = ' + fName + ', last name = ' + lname);
//                 // Get Email address
//                 String emailAddress = emailText.substringBetween('E-mail]', '[image: Address]');
//                 System.debug('Email Address is: ' + emailAddress);
//                 newLead.firstName = fName;
//                 newLead.lastName  = lName;
//                 newLead.Company   = newLead.FirstName + ' ' + newLead.LastName;
//                 newLead.Email     = emailAddress;
//                 newLead.SDR__c    = 'Casey Creech';
//                 insert newLead;
//                 System.debug('New Lead inserted: ' + newLead.Firstname + ' ' + newLead.LastName);
//             } else if (email.subject.contains(subToCompareTwo)) { // IF SOLAR REVIEWS EMAIL
//                 Lead newLead      = new Lead();
//                 List<String> lstLines = new List<String>();
//                 lstLines = emailText.split('\n');
//                 Lead newLead = new Lead();
//                 String temp;
//                 for (String line: lstLines) {
//                     if(line.contains('Requested by:')){
//                         temp = line.substringAfter('Requested by');
//                         String fullName = temp.trim();
//                         String fName    = fullName.substring(0, fullName.indexOf(' '));
//                         String lName    = fullName.substring(fullName.indexOf(' '));
//                         newLead.FirstName = fName;
//                         newLead.LastName  = lName;
//                     }
//                     else if (line.contains('@') && line.contains('.')) {
//                         newLead.Email = line.trim();
//                     }
//                     if (line.contains('Phone:')) {
//                         temp = line.substringAfter('Phone:');
//                         newLead.Phone = temp.trim();
//                     }
//                     // if(line.contains('Address of site:')){
//                     //     temp = line.substringAfter('Address of site:');
//                     //     newLead.Electric_Spend__c = temp.trim();
//                     // }
//                     // continue the same pattern
//                     } // end loop
//                     newLead.SDR__c    = 'Casey Creech';
//                     insert newLead;
//                     System.debug('New Lead inserted: ' + newLead.Firstname + ' ' + newLead.LastName);
//             }

//             // Save attachments, if any
//             if (email.textAttachments != null && email.textAttachments.size() > 0) {
//                 for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
//                     Attachment attachment = new Attachment();
//                     attachment.Name       = tAttachment.fileName;
//                     attachment.Body       = Blob.valueOf(tAttachment.body);
//                     attachment.ParentId   = newLead.Id;
//                     insert attachment;
//                 }
//             }
//         	// Save any Binary Attachment
//             if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
//                 for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
//                     Attachment attachment = new Attachment();
//                     attachment.Name       = bAttachment.fileName;
//                     attachment.Body       = bAttachment.body;
//                     attachment.ParentId   = newLead.Id;
//                     insert attachment;
//                 }
//             }
// 		}
// 	    result.success = true;
//         return result;
//     }
// }

/*
/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class CreateLeadFromEmail implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

		String subToCompareOne = 'HomeAdvisor';
		String subToCompareTwo = 'Solar-Estimate.org';
        String emailText       = email.plainTextBody;
        System.debug(emailText);

		if (email.subject.contains(subToCompareOne) || email.subject.contains(subToCompareTwo)) {
            Lead newLead = new Lead();
            if (email.subject.contains(subToCompareOne)) { // iF HOMEADVISOR EMAIL
                // newLead.LastName  = email.fromName.substring(0, email.fromName.indexOf(' '));
                // newLead.FirstName = email.fromName.substring(email.fromName.indexOf(' '));
                // Get first and last name
                String fullName = emailText.substringBetween('Information', '[image:');
                String fName    = fullName.substring(0, fullName.indexOf(' '));
                String lName    = fullName.substring(fullName.indexOf(' '));
                System.debug('first name = ' + fName + ', last name = ' + lname);
                // Get Email address
                String emailAddress = emailText.substringBetween('E-mail]', '[image: Address]');
                System.debug('Email Address is: ' + emailAddress);
                newLead.firstName = fName;
                newLead.lastName  = lName;
                newLead.Company   = newLead.FirstName + ' ' + newLead.LastName;
                newLead.Email     = emailAddress;
                newLead.SDR__c    = 'Casey Creech';
                insert newLead;
                System.debug('New Lead inserted: ' + newLead.Firstname + ' ' + newLead.LastName);
            } else if (email.subject.contains(subToCompareTwo)) { // IF SOLAR REVIEWS EMAIL
                List<String> lstLines = new List<String>();
                List<String> leadInfoList  = new List<String>();
                lstLines = emailText.split('\n');
                String temp;
                Integer startIndex;
                Integer endIndex;
                System.debug(lstLines);
                // Extract relevant information from the email text
                for (Integer i = 0; i < lstLines.size(); i++) {
                    if (lstLines.get(i).contains('Requested by')) { // start of relevant info
                        startIndex = i;
                    } else if (lstLines.get(i).contains('Address of site')) { // end of relevant info
                        endIndex = i;
                    }
                }
                // create new list of just the relevant info
                for (Integer i = startIndex; i < endIndex + 1; i++) {
                    leadInfoList.add(lstLines.get(i));
                }
                
                System.debug(leadInfoList);
                
                // use releavnt info to set lead field values
                for (String line: leadInfoList) {
                    if(line.contains('Requested by:')){
                        temp = line.substringAfter('Requested by:');
                        String fullName = temp.trim();
                        String fName    = fullName.substring(0, fullName.indexOf(' '));
                        String lName    = fullName.substring(fullName.indexOf(' '));
                        newLead.FirstName = fName;
                        newLead.LastName  = lName;
                        newLead.Company   = fullName;
                    } else if (line.contains('@') && line.contains('.')) {
                        newLead.Email = line.trim();
                    } else  if (line.contains('Phone:')) {
                        temp = line.substringAfter('Phone:');
                        newLead.Phone = temp.trim();
                    } else if (line.contains('Address')) {
                        temp = line.substringAfter('Address of site:');
                        newLead.Phone = temp.trim();
                    }
                 } // end loop
                    newLead.SDR__c    = 'Casey Creech';
                    insert newLead;
                    System.debug('New Lead inserted: ' + newLead.Firstname + ' ' + newLead.LastName);
            	} // END SOLAR REVIEWS EMAIL LOGIC

            // Save attachments, if any
            if (email.textAttachments != null && email.textAttachments.size() > 0) {
                for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name       = tAttachment.fileName;
                    attachment.Body       = Blob.valueOf(tAttachment.body);
                    attachment.ParentId   = newLead.Id;
                    insert attachment;
                }
            }
        	// Save any Binary Attachment
            if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
                for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                    Attachment attachment = new Attachment();
                    attachment.Name       = bAttachment.fileName;
                    attachment.Body       = bAttachment.body;
                    attachment.ParentId   = newLead.Id;
                    insert attachment;
                }
            }
		}
	    result.success = true;
        return result;
    }
}

 *.