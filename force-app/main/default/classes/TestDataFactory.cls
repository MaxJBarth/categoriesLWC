@isTest
public with sharing class TestDataFactory {
  public static Account createAccount() {
    return new Account(Name = 'testAcc');
  }

  public static Category__c createCategory() {
    return new Category__c(Name = 'testCategory');
  }

  public static CategoryAssignment__c createCategoryAssignment() {
    Account acc = TestDataFactory.createAccount();
    insert acc;
    Category__c cat = TestDataFactory.createCategory();
    insert cat;

    return new CategoryAssignment__c(
      RelatedRecordId__c = acc.id,
      CategoryId__c = cat.id
    );
  }

  public static CategoryAssignment__c insertCategoryAssignment() {
    CategoryAssignment__c catAssign = createCategoryAssignment();
    insert catAssign;
    return catAssign;
  }
}
