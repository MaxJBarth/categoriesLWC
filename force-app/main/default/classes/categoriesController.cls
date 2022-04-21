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
    public static void deleteCategoryAssignment(String recordId, String name) {
      List<CategoryAssignment__c> CategoryAssignments = [
        SELECT Id, RelatedRecordId__c, CategoryId__r.Name
        FROM CategoryAssignment__c
        WHERE RelatedRecordId__c = :recordId AND CategoryId__r.Name = :name
        WITH SECURITY_ENFORCED
      ];
      try {
        delete CategoryAssignments;
      } catch (DmlException e) {
      }
    }
  
    @AuraEnabled
    public static void createCategoryAssignment(
      String recordId,
      String category
    ) {
      system.debug('Cat: ' + category);
      List<Category__c> catListid = [
        SELECT Id
        FROM Category__c
        WHERE Category__c.Name = :category
        WITH SECURITY_ENFORCED
        LIMIT 1
      ];
      system.debug('List Debugging' + catListid);
      try {
        system.debug(catListid[0].id);
        CategoryAssignment__c categoryAssign = new CategoryAssignment__c(
          CategoryId__c = catListid[0].id,
          RelatedRecordId__c = recordId
        );
        insert categoryAssign;
      } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
      }
    }
  }
  