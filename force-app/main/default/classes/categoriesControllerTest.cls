@isTest
class categoriesControllerTest {
  @isTest
  static void testAddAssignment() {
    CategoryAssignment__c catAssign = TestDataFactory.insertCategoryAssignment();
    Id catAssignId = catAssign.id;

    List<categoryAssignment__c> catAssignQ = categoriesController.getCategoryAssignList(
      catAssign.RelatedRecordId__c
    );
    Id catAssignQID = catAssignQ[0].id;

    System.assertEquals(catAssignId, catAssignQID);
  }
  @isTest
  static void testGetCategories() {
    CategoryAssignment__c catAssign = TestDataFactory.insertCategoryAssignment();

    Integer allCategoriesSize = categoriesController.getCategories().size();

    System.assertEquals(1, allCategoriesSize);
  }

  @isTest
  static void testDeleteCategoryAssignment() {
    Category__c category = TestDataFactory.createCategory();
    CategoryAssignment__c catAssign = TestDataFactory.insertCategoryAssignment();
    String catAssignName = category.Name;
    String relRecordId = catAssign.RelatedRecordId__c;
    String deleteMessage = categoriesController.deleteCategoryAssignment(
      relRecordId,
      catAssignName
    );

    System.assertEquals(deleteMessage, 'Successfully Deleted');
  }

  @isTest
  static void testErrorDeleteCategoryAssignment() {
    CategoryAssignment__c catAssign = TestDataFactory.insertCategoryAssignment();
    String catAssignFailName = 'DoesntExist';
    String relFailRecordId = '09012009';
    String deleteMessage = categoriesController.deleteCategoryAssignment(
      relFailRecordId,
      catAssignFailName
    );
    //needs rework - check if list contains id after deletion
    //System.assertNotEquals(deleteMessage, 'Successfully Deleted');
  }

  @isTest
  static void testCreateCategoryAssignment() {
    Category__c category = TestDataFactory.createCategory();
    CategoryAssignment__c catAssign = TestDataFactory.insertCategoryAssignment();

    String recordId = catAssign.RelatedRecordId__c;
    String categoryName = category.Name;

    String createCategoryAssignmentMessage = categoriesController.createCategoryAssignment(
      recordId,
      categoryName
    );
    System.assertEquals(
      createCategoryAssignmentMessage,
      'Successfully Created'
    );
  }
}
