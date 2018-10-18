-- -------------------------------------------------------------------------------------------------------------------
-- ATiM v2.7 Read Me
--
-- For more information:
--    http://www.ctrnet.ca/mediawiki/index.php/Main_Page
-- -------------------------------------------------------------------------------------------------------------------


-- -------------------------------------------------------------------------------------------------------------------
-- ATiM Database Creation/Upgrade
-- -------------------------------------------------------------------------------------------------------------------

-- Full installation
-- -----------------

  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.0_full_installation.sql
  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.1_upgrade.sql
  
-- ATiM v2.6.8 upgrade
-- -------------------

  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.0_upgrade.sql
  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.1_upgrade.sql

-- Demo installation
-- -----------------

  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.0_full_installation.sql
  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.1_upgrade.sql
  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < ./DemoData/atim_v2.7.1_demo_data.sql



-- -------------------------------------------------------------------------------------------------------------------
-- ATiM Migration Details & Action Items
-- -------------------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------------------
-- v2.7.0
--   See ATiM Version Release Notes 
--      (http://www.ctrnet.ca/mediawiki/index.php/Version_Release_Notes#v2.7.0)
-- -------------------------------------------------------------------------------------------------------------------

   ### 1 # CakePhp version upgrade and Reformating source code
   -----------------------------------------------------------
 
      ATiM version 2.7.0 is built on the version 2.9.8 of CakePhp. In addition 
      to this upgrade, the source code of ATiM has been reformated to be more compliant 
      with the CakePhp coding standards. 
         (See https://book.cakephp.org/2.0/en/contributing/cakephp-coding-conventions.html)

      TODO :

      In any custom files (see app/Plugin/*/Hook and app/Plugin/*/Custom directory),  
      reformat custom code following the instructions below. Note that all php scripts 
      listed into the instructions are located in '/scripts/v2.7.0/CustomCodeSnifer/'.

         I - Reformat custom code to PSR-2 coding style

              Instructions for eclipse:
                  a. Window>preferences>PHP>Formatter.
                  b. Choose PSR2>OK
                  c. Click on the app folder of project in PHP Explorer
                  d. Press Ctrl+Shift+F.

         II - Replace flash with atimFlashWarning, atimFlashInfo, atimFlashConfirm 
           or atimFlashError

         III - Remove php deprecated function in php 7.0

              Use explode instead of split

         IV - Replace 'else if' with 'elseif'

              Use replacement function in editor (Eclipse or netbeans) to replace 
              regular expression 'else\s\s*if' with 'elseif'

         V - Delete '?>' at the end of pure PHP files (if you don't add --commit option the changes will be logged in a file without effecting the codes)

              Linux or mac:
					php ./CustomCodeSnifer/RemovePhpTagAndSpaceAtTheEndOfFile-custom.php /.../atim/app --commit
			  windows: 
					php CustomCodeSnifer\RemovePhpTagAndSpaceAtTheEndOfFile-custom.php ..\..\app --commit

         VI - Change case (from uppercase to lowercase) for NULL, FALSE and TRUE

              Use replacement function in editor

         VII - Change the 'function' to 'public function' in the class (if you don't add --commit option the changes will be logged in a file without effecting the codes)

              Linux or mac:
					php ./CustomCodeSnifer/addPublic-custom.php /.../atim/app --commit
              Windows: 
					php CustomCodeSnifer\addPublic-custom.php ..\..\app --commit
				

         VIII - Change the underscore_case to camelCase (if you don't add --commit option the changes will be logged in a file without effecting the codes)

              Linux or mac:
					php ./CustomCodeSnifer/snakeToCamel-custom.php /.../atim --commit
              Windows: 
					php CustomCodeSnifer\snakeToCamel-custom.php ..\..\app --commit


   ### 2 # 'recursive' function is now type sensitive
   -----------------------------------------------------------

      Replaced any code matching ['recursive' => 'integer_value'] by ['recursive' => integer_value].

      For example:
          $this->Model->find('first', array(
              'conditions' => array(),
              'recursive' => '1'
          ));

      Replaced by:
          $this->Model->find('first', array(
              'conditions' => array(),
              'recursive' => 1
          ));

      TODO :

      Parse any custom code to apply the same change.


   ### 3 # Custom AutoCompleteField Function
   -----------------------------------------------------------

      The autocomplete field did not work in v2.6.8 version for any values having special characters like {\%'"}.
      See "issue#3398: autoComplete and special characters". 
   
      The following functions of controllers and models used to generate the autocomplete lists, to format the displayed values 
      and to validate the selected values have been modified :
      
         - DrugsController.autocompleteDrug() and Drug.getDrugIdFromDrugDataAndCode()
         	  Field : Drug.generic_name
         	  Correction : Autocomplete and validation
         - AliquotMastersController.autocompleteBarcode()
         	  Field : AliquotMaster.barcode
         	  Correction : Autocomplete only
         - StorageMastersController.autocompleteLabel() and StorageMaster.getStorageDataFromStorageLabelAndCode()
         	  Field : StorageMaster.Selection_label
         	  Correction : Autocomplete and validation
         - TmaSlides.autocompleteBarcode()
         	  Field : TmaSlide.barcode
         	  Correction : Autocomplete only
         - TmaSlides.autocompleteTmaSlideImmunochemistry()
         	  Field : TmaSlide.immunochemistry
              Correction : Autocomplete only
         - StudySummaries.autocompleteStudy() and StudySummary.getStudyIdFromStudyDataAndCode()
         	  Field : StudySummary.title
              Correction : Autocomplete and validation
      
      In Controller function (like autocompleteDrug()) :
         - Special characters of the $term have been formatted using str_replace()
   			  $term = str_replace(array( "\\", '%', '_'), array("\\\\", '\%', '\_'), $_GET['term']);
         - Search conditions have been changed  
   			  from Model.Field LIKE '%" . trim($keyWord) . "%'",
   			  to Model.Field LIKE " => '%' . trim($keyWord) . '%', 
         - Returned value has been formatted using str_replace()  
   			  $result = "";
   			  foreach ($data as $dataUnit) {
   			     $result .= '"' . str_replace(array('\\', '"'), array('\\\\', '\"'), dataUnit . '", ';
   			  }
      
      In Model funtions (like getDrugIdFromDrugDataAndCode($drugDataAndCode)) :   
         - Special characters of the submitted value (like $drugDataAndCode) have been formatted using str_replace()
   			  $submitedValue = str_replace(array( "\\", '%', '_'), array("\\\\", '\%', '\_'), $submittedValue);
         - Search conditions have been changed
   			  from Model.Field LIKE '%" . trim($submittedValue) . "%'",
   			  to Model.Field LIKE " => '%' . trim($submittedValue) . '%',
   
      TODO :  
   
      Update custom code for any function listed above and being overridden by a custom function.


   ### 4 # New content in collection tree view upgrade
   -----------------------------------------------------------
   
      Quality control and path review are now displayed into the collection tree view when they are not linked 
      to a tested aliquot. See "issue#3427: Add quality control and tissue review to collection tree view when data 
      is not linked to an aliquot". 
   
      TODO :  
   
      Review structure 'sample_uses_for_collection_tree_view' and function SampleMastersController.contentTreeView() for
      any customisation.



-- -------------------------------------------------------------------------------------------------------------------
-- v2.7.1
--   See ATiM Version Release Notes 
--      (http://www.ctrnet.ca/mediawiki/index.php/Version_Release_Notes#v2.7.1)
-- -------------------------------------------------------------------------------------------------------------------

   ### 1 # Collection Protocols
   -----------------------------------------------------------
 
      Improvement of the Template tool allowing user to create Collection Protocols being a list of collections a participant
      is supposed to have. The tool lets users to define the timeline, the default values of each collection 
      plus which collection templates to use for each visit.
   
      TODO :  
   
      Create Hook file \app\Plugin\Tools\View\Template\Hook\listProtocolsAndTemplates_protocol.php and 
      add code to not display the Collection Protocols sub list and add protocol button.
      
         $displayNextForm = false;
         $links = array(
             'bottom' => array(
                 'add' => '/Tools/Template/add/'
             )
         );

      Hide all fields displaying protocol data into Inventory Management module.
      
         UPDATE structure_formats SET `flag_search`='0', `flag_index`='0', `flag_detail`='0', `flag_summary`='0' 
         WHERE structure_id=(SELECT id FROM structures WHERE alias='view_collection') 
         AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='ViewCollection' AND `tablename`='' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

         UPDATE structure_formats SET `language_heading`='collection' 
         WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
         AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='acquisition_label' AND `structure_value_domain`  IS NULL  AND `flag_confidential`='0');

         UPDATE structure_formats SET `language_heading`='', `flag_index`='0' 
         WHERE structure_id=(SELECT id FROM structures WHERE alias='clinicalcollectionlinks') 
         AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');

         UPDATE structure_formats SET `flag_index`='0', `flag_summary`='0' 
         WHERE structure_id=(SELECT id FROM structures WHERE alias='collections_for_collection_tree_view') 
         AND structure_field_id=(SELECT id FROM structure_fields WHERE `model`='Collection' AND `tablename`='collections' AND `field`='collection_protocol_id' AND `structure_value_domain` =(SELECT id FROM structure_value_domains WHERE domain_name='collection_protocols') AND `flag_confidential`='0');
 
      Check if Hook files exist on your local installation for the View '\app\Plugin\ClinicalAnnotation\View\ClinicalCollectionLinks\listall.ctp'
      and check if $addButtonLinks is managed by these Hooks and have to be updated to support Collection Ptotocols.

 
   ### 2 # Database connection details : 'persistent' field
   -----------------------------------------------------------
   
      To guarantee that the right error page will be displayed when database connection fails, be sure that the 'persistent' is set to 'false'.
   
         public $default = array(
           'datasource' => 'Database/Mysql',
           'persistent' => false,
           'host' => '127.0.0.1',
           'login' => 'root',
           'password' => '',
           'database' => 'v27z',
           'prefix' => '',
           'encoding' => 'utf8',
           'port' => 3306
         );
   
   
   ### 3 # ReportsControllerCustom & javascript:history.back()
   -----------------------------------------------------------
   
   The code 'javascript:history.back()' does not work into ReportsControllerCustom functions.
   
   TODO: 
   
   Check if a ReportsControllerCustom has been developed on your local installation and replace any code ['javascript:history.back()'] by [Router::url(null , true)]
   
   
   ### 4 # UserAnnouncementsController
   -----------------------------------------------------------
   
   The AnnouncementsController of the Customize plugin has been renamed to UserAnnouncementsController to remove all conflicts with the AnnouncementsController of the 
   Administrate plugin. 
   
   TODO: 
   
   Check if custom hooks have been developed for the Announcements controller (\app\Plugin\Customize\Controller\AnnouncementsController.php) 
   and view (\app\Plugin\Customize\View\Announcements) into the Customize plugin for your local installation.
   
   Replace all custom code, custom file names or custom folder names of this plugin that contain Announcements by UserAnnouncements

   
   ### 5 # New pre_search_handler Hooks
   -----------------------------------------------------------
   
   A new hook call has been added before any searchHandler() call.
   
   TODO: 
   
   Check if custom hook 'format' has been developed for the search function of the StudySummaries controller. One of the hook
   has been replaced by the new hook name.

   
   ### 6 # Upload file feature
   -----------------------------------------------------------
   
   A new type of field has been created for downloading files on server (pdf, jpg, etc).
   
   TODO: 
   
   See page 'How to upload file on server with ATiM feature' on ATiM wiki to create specific fields.
   (http://www.ctrnet.ca/mediawiki/index.php?title=How_to_upload_file_on_server_with_ATiM_feature)
   
   Set path of the server directory to the core variable 'uploadDirectory'.
   Change directory permissions.
   (See http://www.ctrnet.ca/mediawiki/index.php?title=ATiM_Installation_Guide#Quick_Install_Guide_.28Step_by_Step.29)
   
   ### 7 # Charts feature to complete reports
   -----------------------------------------------------------
   
   A new feature has been developed to add charts to reports.
   
   TODO: 
   
   See page 'How to create a report' on ATiM wiki to create specific charts.
   (http://www.ctrnet.ca/mediawiki/index.php?title=How_to_create_a_report#Graphics)

   
   ### 8 # Option to copy user logs data to a server file
   -----------------------------------------------------------
   
   A new feature has been developed to copy part of the information of the user_logs table to a file created on the server.
   
   TODO: 
   
   Set path of the server directory to the core variable 'atim_user_log_output_path'.
   Change directory permissions.
   (See http://www.ctrnet.ca/mediawiki/index.php?title=ATiM_Installation_Guide#Quick_Install_Guide_.28Step_by_Step.29)

   
   ### 9 # LDAP
   -----------------------------------------------------------
   
   A new feature has been developed to use LDAP as the authentifcation process.
   
   TODO: 
   
   Set core variables : 'if_use_ldap_authentication', etc. 
   
   See page 'ATiM Installation Guide' on ATiM wiki to have more details.
   (http://www.ctrnet.ca/mediawiki/index.php?title=ATiM_Installation_Guide)

   
   ### 10 # Views update
   -----------------------------------------------------------
   
   Following views have been modified: ViewCollection, ViewSample, ViewAliquot and ViewStorageMaster.
   
   TODO: 
   
   Update views in custom models (ViewCollectionCustom, ViewSampleCustom, ViewAliquotCustom and ViewStorageMasterCustom) if exist.
   
   
   ### 11 # OrderItems.editInBatch() & orderitems_returned
   -----------------------------------------------------------
   
   Function OrderItems.edit() is now deprecated and replaced by OrderItems.editInBatch().
   
   Structure 'orderitems_returned' has been deleted.
   
   TODO: 
   
   Migrate custom codes and hooks from edit to editInBatch if exist. 
   
   Check that no custom code and hook use 'orderitems_returned' structure.
   
   
   ### 12 # Variable $structureOverride
   -----------------------------------------------------------
   
   Any variable '$override' has been renamed to '$structureOverride' to be consistent all over the code.
   
   TODO: 
   
   Rename any variable '$override' to '$structureOverride' in custom code or hooks if exist.
   Rename any variable '$overrideData' to '$structureOverride' in custom code or hooks if exist.
   Rename any variable '$createdSampleOverrideData' to '$createdSampleStructureOverride' in custom code or hooks if exist.
   Rename any variable '$createdAliquotOverrideData' to '$createdAliquotStructureOverride' in custom code or hooks if exist.
   
   Replace any code "$this->set('override'" by "$this->set('structureOverride'" in custom code or hooks if exist.
   Replace any code "$this->set('overrideData'" by "$this->set('structureOverride'" in custom code or hooks if exist.
   Replace any code "$this->set('createdSampleOverrideData'" by "$this->set('createdSampleStructureOverride'" in custom code or hooks if exist.
   Replace any code "$this->set('createdAliquotOverrideData'" by "$this->set('createdAliquotStructureOverride'" in custom code or hooks if exist.
   
   
   ### 13 # Material tool clean up
   -----------------------------------------------------------
   
   Material tool has been cleaned up and is now functional and the Material Model in SOP plugin has been deleted. 
   
   TODO: 
   
   Check that no custom code and hook use 'Material' model, functions else migrate custom codes and hooks.
   
   
   ### 14 # Test version
   -----------------------------------------------------------
   
   Added a $isTest core variable to display install name as a test version (in red + Test word) or as usual. 
   
   TODO: 
   
   Set core variable 'isTest' to 1 to display ATiM as a test version.
   
      
    ### 15 # Collection Template Default Values
   -----------------------------------------------------------
   
   Added a new feature to set default values for each node of a Collection Template. 
   
   TODO: 
   
   Review any following custom code files (if exist) to check if these one manage default values. Replace custom code (if possible) to use 
   Collection Template default values feature instead of custom code. Remove unnecessary custom code used to manage default values.
	
   See files:
	   - \app\Plugin\InventoryManagement\Controller\Hook\AliquotMasters_add_initial_display.php
	   - \app\Plugin\InventoryManagement\Controller\Hook\SampleMasters_add_initial_display.php
