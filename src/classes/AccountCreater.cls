/**
 * First webservice to fetch an account with the External Id.
 *
 */
 @RestResource(urlMapping='/v1/accounts/*')
 global with sharing class AccountCreater {

 	@HttpGet
 	global static AccountWrapper doGet() {

 		RestRequest req = new RestRequest();
 		RestResponse res = new RestResponse();
 		AccountWrapper wrapAccount = new AccountWrapper();

		Account account = [Select id,name from Account where External_Id__c = '21' limit 1];
		

		if(account != null ) {
			wrapAccount.acc = account;
			wrapAccount.accountId = account.Id;
			wrapAccount.accountName = account.name;

		}else {
			wrapAccount.accountName = 'NoNAme';
			res.statusCode = 404;

		}
		return wrapAccount;

 	}

 	global class AccountWrapper {

 		public account acc;
 		public Id accountId;
 		public String accountName;

 		public AccountWrapper(){}
 	}
 }