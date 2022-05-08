public with sharing class categoriesController {
  @AuraEnabled(cacheable=true)
  public static List<CategoryAssignment__c> getCategoryAssignList(Id recordId) {
    List<CategoryAssignment__c> CategoryAssignments = [
      SELECT id, CategoryId__c, RelatedRecordId__c, CategoryId__r.Name
      FROM CategoryAssignment__c
      WHERE RelatedRecordId__c = :recordId
      WITH SECURITY_ENFORCED
    ];
    return CategoryAssignments;
  }

  @AuraEnabled(cacheable=true)
  public static List<Category__c> getCategories() {
    List<Category__c> allCategories = [
      SELECT id, Name
      FROM Category__c
      WITH SECURITY_ENFORCED
    ];
    return allCategories;
  }

  @AuraEnabled
  public static string deleteCategoryAssignment(String recordId, String name) {
    List<CategoryAssignment__c> CategoryAssignments = [
      SELECT Id, RelatedRecordId__c, CategoryId__r.Name
      FROM CategoryAssignment__c
      WHERE RelatedRecordId__c = :recordId AND CategoryId__r.Name = :name
      WITH SECURITY_ENFORCED
    ];
    try {
      delete CategoryAssignments;
      return 'Successfully Deleted';
    } catch (DmlException e) {
      return e.getMessage();
    }
  }

  @AuraEnabled
  public static string createCategoryAssignment(
    String recordId,
    String category
  ) {
    List<Category__c> catListid = [
      SELECT Id
      FROM Category__c
      WHERE Category__c.Name = :category
      WITH SECURITY_ENFORCED
      LIMIT 1
    ];
    try {
      CategoryAssignment__c categoryAssign = new CategoryAssignment__c(
        CategoryId__c = catListid[0].id,
        RelatedRecordId__c = recordId
      );
      insert categoryAssign;
      return 'Successfully Created';
    } catch (DmlException e) {
      throw new AuraHandledException(e.getMessage());
    }
  }
}
