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
                System.Debug('Relevant Information = ' + leadInfoList);

                // use releavant info to set lead field values
                for (Integer i = 0; i < leadinfoList.size(); i++) {
                    if(leadInfolist.get(i).contains('Customer Information')){
                        // set name
                        temp = leadInfoList.get(i+1);
                        String fullName = temp.trim();
                        String fName    = fullName.substring(0, fullName.indexOf(' '));
                        String lName    = fullName.substring(fullName.indexOf(' '));
                        newLead.FirstName = fName;
                        newLead.LastName  = lName;
                        newLead.Company   = fullName;
                    } else if (leadInfoList.get(i).contains('@') && leadInfoList.get(i).contains('.')) {
                        // set email
                        newLead.Email = leadInfoList.get(i).trim();
                    } else  if (leadInfoList.get(i).contains('Phone')) {
                        // set phone
                        temp = leadInfoList.get(i).substringAfterLast('/');
                        temp = temp.replace('>', '');
                        temp = temp.trim();
                        // temp = temp.substringafter(' ');
                        // temp = temp.trim();
                        // temp = temp.substringbeforeLast(' ');
                        // temp = temp.trim();
                        newLead.Phone = temp;
                    } else if (leadInfoList.get(i).contains('Address')) {
                        // set address
                        temp = leadInfoList.get(i);
                        temp = temp.replace(temp.subStringBefore('Address'), '');
                        temp = temp.trim();
                        temp = temp.subStringAfter(' ').trim();
                        System.debug('Full Address = ' + temp);

                        String streetAddress = temp.subStringBefore(',');
                        streetAddress = streetAddress.trim();
                        newLead.Project_Address__c = streetAddress;
                        newLead.Mailing_Address__c = streetAddress;
                        System.debug('Street Address = ' + streetAddress);

                        String cityStateZip = temp.substringAfter(',');
                        cityStateZip = cityStateZip.trim();
                        System.debug('City, State Zip = ' + cityStateZip);

                        String city = cityStateZip.substringBefore(',');
                        city = city.trim();
                        newLead.Project_City__c = city;
                        newLead.Mailing_City__c = city;
                        System.debug('City = ' + city);

                        String stateZip = cityStateZip.substringAfter(',');
                        stateZip = stateZip.trim();
                        System.debug('State, Zip = ' + stateZip);
                                    
                        String state = stateZip.substringBefore(' ');
                        state = state.trim();
                        newLead.Project_State__c = state;
                        newLead.Mailing_State__c = state;
                        System.debug('State = ' + state);

                        String zipCode = stateZip.substringAfter(' ');
                        zipCode = zipCode.trim();
                        newLead.Project_Zip_Code__c = zipCode;
                        newLead.Mailing_Zip_Code__c = zipCode;
                        System.debug('Zip = ' + zipCode);
                    }
                 } // end loop
                    newLead.SDR__c     = 'Justin Creech';
                    newLead.LeadSource = 'Home Advisor';
                    newLead.Energy_Consultant__c = 'NONE';
                    newLead.Solar_Review_Home_Advisor_Notes__c = emailText.substringBetween('You have a new lead!', 'Tips from HomeAdvisor');
                    insert newLead;
                    System.debug('New Lead inserted: ' + newLead.Firstname + ' ' + newLead.LastName);
            	} // END HOME ADVISOR LOGIC
            else if (email.subject.contains(subToCompareTwo)) { // IF SOLAR REVIEWS EMAIL
                List<String> lstLines      = new List<String>();
                List<String> leadInfoList  = new List<String>();
                lstLines = emailText.split('\n');
                String  temp;
                Integer startIndex;
                Integer endIndex;
                System.debug(lstLines);
                // Extract relevant information from the email text
                for (Integer i = 0; i < lstLines.size(); i++) {
                    if (lstLines.get(i).contains('Requested by')) { // start of relevant info
                        startIndex = i;
                    } else if (lstLines.get(i).contains('Utility Company')) { // end of relevant info
                        endIndex = i;
                    }
                }
                // create new list of just the relevant info
                for (Integer i = startIndex; i < endIndex + 1; i++) {
                    leadInfoList.add(lstLines.get(i));
                }
                
                System.Debug('Relevant Information = ' + leadInfoList);
                
                // use relevant info to set lead field values
                for (Integer i = 0; i < leadInfoList.size(); i++) {
                    if(leadInfoList.get(i).contains('Requested by:')){
                        // set name
                        temp = leadInfoList.get(i).substringAfter('Requested by:');
                        String fullName = temp.trim();
                        String fName    = fullName.substring(0, fullName.indexOf(' '));
                        String lName    = fullName.substring(fullName.indexOf(' '));
                        newLead.FirstName = fName;
                        newLead.LastName  = lName;
                        newLead.Company   = fullName;
                    } else if (leadInfoList.get(i).contains('@') && leadInfoList.get(i).contains('.')) {
                        // set email
                        newLead.Email = leadInfoList.get(i).trim();
                    } else  if (leadInfoList.get(i).contains('Phone:')) {
                        // set phone
                        temp          = leadInfoList.get(i).substringAfter('Phone:');
                        newLead.Phone = temp.trim();
                    } else if (leadInfoList.get(i).contains('Address')) {
                        // set address
                        temp = leadInfoList.get(i).substringAfter('Address of site:');
                        newLead.Project_Address__c = temp.trim();
                        newLead.Mailing_Address__c = temp.trim();
                        // parse the City, State, and Zip
                        String cityStateZip = leadInfoList.get(i+1);
                        cityStateZip        = cityStateZip.trim();
                        String lzipCode     = cityStateZip.substringAfterLast(' ');
                        //  Set Zip Code
                        newLead.Project_Zip_Code__c = lzipCode.trim();
                        newLead.Mailing_Zip_Code__c = lzipCode.trim();
                        String cityState    = cityStateZip.remove(lzipCode);
                        cityState           = cityState.trim();
                        String lstate       = cityState.substringAfterLast(' ');
                        // Set State
                        newLead.Project_State__c = lstate.trim();
                        newLead.Mailing_State__c = lstate.trim();
                        String lcity             = cityState.substringBeforeLast(' ');
                        // Set City
                        newLead.Project_City__c  = lcity.trim();
                        newLead.Mailing_City__c  = lcity.trim();
                    } /* else if (leadInfoList.get(i).contains('Utility Company')) { // UTILITY COMPANY
                        // set utility company
                        temp = leadInfoList.get(i).substringAfter('Utility Company:');
                        temp = temp.trim();
                        System.debug('Utility Company from Email = ' + temp);
                        if (temp != null && !temp.equalsIgnoreCase('other')) {
                            List<Account> utilityCompany = [
                                SELECT Id, Name
                                  FROM Account
                                 WHERE Name = :temp
                                 LIMIT 1
                            ];
                             System.debug('Result from Utility Company Query = ' + utilityCompany);
                            if (!utilityCompany.isEmpty()) { // utility company already in org
                               
                                newLead.Utility_Company__c = utilityCompany.get(0).Id;
                                System.debug('Matching Utility Company was found! ' + utilityCompany.get(0).Name);
                            } else if (utilityCompany.isEmpty()){ // if utility company is not in org, create one
                                System.debug('No matching Utitlity Company was found!');
                                Account newAccount = new Account();
                                newAccount.Name = temp;
                                Id RecordTypeIdUtilityCompany = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Utility Company').getRecordTypeId();
								System.debug('Utility Company record type = ' + RecordTypeIdUtilityCompany);
                                // set record type to utility company
                                newAccount.RecordTypeId = RecordTypeIdUtilityCompany;
                                insert newAccount;
                                // add utility company to lead
                                newLead.Utility_Company__c = newAccount.Id;
                                System.debug('Utility Company created! ' + newAccount.Name);
                            }
                        }
                    } */
                 } // end loop // end loop
                    newLead.SDR__c    = 'Justin Creech';
                    newLead.LeadSource = 'solarreviews.com';
                    newLead.Energy_Consultant__c = 'NONE';
                    newLead.Solar_Review_Home_Advisor_Notes__c = emailText.substringAfter('make a request.');
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