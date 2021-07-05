public class CandidateFormSaveCtrl {


	@AuraEnabled
	public static void saveCandidate(String candidateJSON, String assignmentId, String originFieldName, String originValue, String defaultAccountId) {
		System.debug(candidateJSON);
		ItemCandidate candidate = (ItemCandidate)JSON.deserialize(candidateJSON, ItemCandidate.class);
		

		Map<String, String> accountIdMapByName = new Map<String, String>();
		String accountCurrentId = '';
		//Create the company's contact
		if(candidate.companiesExecutif!=null) {
			if(!candidate.companiesExecutif.isEmpty()) {
				for(ItemCompany cie: candidate.companiesExecutif) {
					//Create companies's biography for higher direction
					Account account = new Account(Name=cie.name, Type__c=cie.cieType,Industries__c=cie.secteur, Chiffre_d_affaires__c=cie.revenue);
					account.Stade_de_d_veloppement__c = cie.stade;
					
					insert account;

					accountIdMapByName.put(account.Name, account.Id);

					if(cie.endYear==null || cie.endYear=='')
						accountCurrentId = account.Id;
				}
			}
		}

		//Create the contact
		Contact people = new Contact();
		//Set Candidate Info
		people.firstName = candidate.firstName;
		people.lastName = candidate.lastName;
		people.email = candidate.email;
		people.phone = candidate.phoneNumber;

		//Set default account Id
		if(defaultAccountId!=null && defaultAccountId!='') {
			people.AccountId = defaultAccountId;
		}

		if(accountCurrentId!='') {
			people.AccountId = accountCurrentId;
		}



		//Set Competencies
		if(candidate.domains!=null) {
			if(!candidate.domains.isEmpty()) {
				Integer i=0;
				for(ItemDomain domain: candidate.domains) {
					if(i==0) {
						people.Comp_tences_5__c = domain.name;
						String cmps1 = '';
				        Boolean start = true;
				        if(domain.competencies!=null) {
					        if(!domain.competencies.isEmpty()) {           
					            for(String cmp1 : domain.competencies) {
					                if(start) {
					                    cmps1 = cmp1;
					                    start = false;
					                } else {               
					                    cmps1 = cmps1 + ';' + cmp1;
					                }
					            }
					            people.Domaine_comp_tence_1__c = cmps1;
					        }
					    }
					} else if(i==1) {
						people.Domaine_d_expertise_6__c = domain.name;
						String cmps2 = '';
				        Boolean start = true;
				        if(domain.competencies!=null) {
					        if(!domain.competencies.isEmpty()) {           
					            for(String cmp2 : domain.competencies) {
					                if(start) {
					                    cmps2 = cmp2;
					                    start = false;
					                } else {               
					                    cmps2 = cmps2 + ';' + cmp2;
					                }
					            }
					            people.Domaine_comp_tence_2__c = cmps2;
					        }
					    }

						break;
					}
					i++;
				}
			}
		}

		//Set locations 
		String locations = '';
        Boolean start = true;
        if(candidate.area!=null) {
	        if(!candidate.area.isEmpty()) {           
	            for(String location : candidate.area) {
	                if(start) {
	                    locations = location;
	                    start = false;
	                } else {               
	                    locations = locations + ';' + location;
	                }
	            }
	            people.Zone_s_g_ographique_s__c = locations;
	        }
	    }

		//Set Profesionnal Title
		String profesionnalTitles = '';
        start = true;
        if(candidate.order!=null) {
	        if(!candidate.order.isEmpty()) {           
	            for(String profesionnalTitle : candidate.order) {
	                if(start) {
	                    profesionnalTitles = profesionnalTitle;
	                    start = false;
	                } else {               
	                    profesionnalTitles = profesionnalTitles + ';' + profesionnalTitle;
	                }
	            }
	            people.Titre_professionnel__c = profesionnalTitles;
	        }
	    }

	    if(candidate.otherOrder!=null && candidate.otherOrder!='') {
	    	if(people.Titre_professionnel__c!=null && people.Titre_professionnel__c!='') {
	    		people.Titre_professionnel__c = people.Titre_professionnel__c +';'+candidate.otherOrder;
	    	} else {
	    		people.Titre_professionnel__c = candidate.otherOrder;
	    	}
	    }

		//Set Absence
		people.Absence_du_Qu_bec__c = candidate.absence;

		//Set comittee interest
		people.Int_r_t_pour_un_comit__c = candidate.comittee; 

		//Set summary
		people.Sommaire__c = candidate.summary;

		
		if(candidate.companiesExecutif!=null) {
			if(candidate.companiesExecutif.isEmpty()) {
				people.Title= 'Administrateur de société';
			}
		} else {
			people.Title= 'Administrateur de société';
		}

		if(candidate.companiesPrimary!=null) {
			if(candidate.companiesPrimary.isEmpty()) {
				people.Title= 'Administrateur de société';
			}
		} else {
			people.Title= 'Administrateur de société';
		}


		insert people;

		if(candidate.fileCV!=null && candidate.fileCV!='') {
			Attachment att = new Attachment(Name='CV', ParentId=people.Id, ContentType=candidate.contentType, Body=EncodingUtil.base64Decode(candidate.fileCV));

			insert att;
		}

		if(candidate.fileCV2!=null && candidate.fileCV2!='') {
			Attachment att = new Attachment(Name='CV', ParentId=people.Id, ContentType=candidate.contentType2, Body=EncodingUtil.base64Decode(candidate.fileCV2));

			insert att;
		}

		
		List<Work_Experience__c> biographies = new List<Work_Experience__c>();
		
		//Create Biography for orders
		if(candidate.order!=null) {
	    	if(!candidate.order.isEmpty()) { 
				for(String profesionnalTitle : candidate.order) {
					Work_Experience__c profesionnalTitleBio = new Work_Experience__c(RecordTypeId='012U0000000QRzG');
					profesionnalTitleBio.Title__c = profesionnalTitle;
					profesionnalTitleBio.Contact__c = people.Id;
					
					biographies.add(profesionnalTitleBio);
				}
			}
		}

		if(candidate.otherOrder!=null && candidate.otherOrder!='') {
			Work_Experience__c profesionnalTitleBio = new Work_Experience__c(RecordTypeId='012U0000000QRzG');
			profesionnalTitleBio.Title__c = candidate.otherOrder;
			profesionnalTitleBio.Contact__c = people.Id;
			
			biographies.add(profesionnalTitleBio);
		}

		//Create Biography for governance
		if(candidate.companiesPrimary!=null) {
			if(!candidate.companiesPrimary.isEmpty()) {
				people.Title= 'Administrateur de société';
				for(ItemCompany cie: candidate.companiesPrimary) {
					//Create companies's biography for governance
					Account account = new Account(Name=cie.name, Type__c=cie.cieType,Industries__c=cie.secteur, Chiffre_d_affaires__c=cie.revenue);
					
					insert account;

					Work_Experience__c profesionnalTitleBio = new Work_Experience__c(RecordTypeId='012U0000000QRzL');
					profesionnalTitleBio.Title__c = cie.fonction;
					profesionnalTitleBio.Contact__c = people.Id;
					profesionnalTitleBio.Company__c = account.Id;
					profesionnalTitleBio.Start_Year__c = cie.startYear;
					
					if(cie.endYear==null || cie.endYear=='') {
						profesionnalTitleBio.Current_del__c = true;
					}
					else
						profesionnalTitleBio.End_Year__c = cie.endYear;
					biographies.add(profesionnalTitleBio);

				}

			}
		}


		//Create Biography for higher direction
		if(candidate.companiesExecutif!=null) {
			if(!candidate.companiesExecutif.isEmpty()) {
				for(ItemCompany cie: candidate.companiesExecutif) {
					//Create companies's biography for higher direction
					String accountId = null;
					if(accountIdMapByName.containsKey(cie.name))
						accountId = accountIdMapByName.get(cie.name);

					Work_Experience__c profesionnalTitleBio = new Work_Experience__c(RecordTypeId='012U0000000QRzL');
					profesionnalTitleBio.Title__c = cie.fonction;
					profesionnalTitleBio.Contact__c = people.Id;
					profesionnalTitleBio.Company__c = accountId;
					profesionnalTitleBio.Start_Year__c = cie.startYear;
					
					if(cie.endYear==null || cie.endYear=='') {
						profesionnalTitleBio.Current_del__c = true;
					}
					else
						profesionnalTitleBio.End_Year__c = cie.endYear;
					biographies.add(profesionnalTitleBio);

				}

			} 
		} 

		insert biographies;

		if(assignmentId!=null && assignmentId!='') {
			Application__c application = new Application__c(Mandate__c=assignmentId,Contact__c=people.Id);
			insert application;
			
		}

	}



	public class ItemCandidate {

		@AuraEnabled
		public String lastName {get;set;}

		@AuraEnabled
		public String firstName {get;set;}

		@AuraEnabled
		public String email {get;set;}

		@AuraEnabled
		public String phoneNumber {get;set;}

		@AuraEnabled
		public String absence {get;set;}

		@AuraEnabled
		public String comittee {get;set;}

		@AuraEnabled
		public String summary {get;set;}

		@AuraEnabled
		public String otherOrder {get;set;}

		@AuraEnabled
		public String fileCV {get;set;}

		@AuraEnabled
		public String contentType {get;set;}

		@AuraEnabled
		public String fileCV2 {get;set;}

		@AuraEnabled
		public String contentType2 {get;set;}

		@AuraEnabled
		public List<String> area {get;set;}

		@AuraEnabled
		public List<String> order {get;set;}

		@AuraEnabled
		public List<ItemCompany> companiesPrimary {get;set;}

		@AuraEnabled
		public List<ItemCompany> companiesExecutif {get;set;}

		@AuraEnabled
		public List<ItemDomain> domains {get;set;}

	}

	public class ItemCompany {

		@AuraEnabled
		public String name {get;set;}

		@AuraEnabled
		public String cieType {get;set;}

		@AuraEnabled
		public String stade {get;set;}

		@AuraEnabled
		public String secteur {get;set;}

		@AuraEnabled
		public String revenue {get;set;}

		@AuraEnabled
		public String fonction {get;set;}

		@AuraEnabled
		public String startYear {get;set;}

		@AuraEnabled
		public String endYear {get;set;}

	}

	public class ItemDomain {

		@AuraEnabled
		public String name {get;set;}

		@AuraEnabled
		public List<String> competencies {get;set;}


	}


}