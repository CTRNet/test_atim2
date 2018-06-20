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
      not linked to an aliquot". 
   
      TODO :  
   
      Review structure 'sample_uses_for_collection_tree_view' and function SampleMastersController.contentTreeView() for
      any customisation.



-- v2.7.1
--   See ATiM Version Release Notes 
--      (http://www.ctrnet.ca/mediawiki/index.php/Version_Release_Notes#v2.7.1)
-- -------------------------------------------------------------------------------------------------------------------

   ### 1 # Collection protocols
   -----------------------------------------------------------
 
      New features added to the Template tool to let user to create collections protocols (definition of a list of collections 
      a participant is supposed to participate defining the timeline, the default values and also the collection templates to use).
   
      TODO :  
   
      Create file \app\Plugin\Tools\View\Template\Hook\listProtocolsAndTemplates_protocol.php and add code to not display the Collection Protocols sub list and add protocol option.

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
 
 
   ### 2 # Database connection details : 'persistent' field
   -----------------------------------------------------------
   
      To guarantee that the right error page will be displayed when database connection will failed, be sure that the 'persistent' is set to 'false'.
   
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
   
   Check if a ReportsControllerCustom has been developped for your local installation and replace code ['javascript:history.back()'] by [Router::url(null , true)]
   
   
   ### 3 # UserAnnouncementsController
   -----------------------------------------------------------
   
   The AnnouncementsController of the Customize plugin has been renamed to UserAnnouncementsController to remove all conflicts the AnnouncementsController of the 
   Administrate plugin. 
   
   TODO: 
   
   Check if custom hooks have been developped for the Announcements controller (\app\Plugin\Customize\Controller\AnnouncementsController.php) 
   and view (\app\Plugin\Customize\View\Announcements) into the Customize plugin for your local installation.
   
   Replace all custom code, custom file names or custom folder names of this plugin that contain Announcements by UserAnnouncements

   
   ### 3 # New pre_search_handler Hooks
   -----------------------------------------------------------
   
   A new hook call has been added before any searchHandler() call.
   
   TODO: 
   
   Check if custom hook 'format' has been developped for the search function of the StudySummaries controller. One of the hook
   has been replaced by the new hook name.
