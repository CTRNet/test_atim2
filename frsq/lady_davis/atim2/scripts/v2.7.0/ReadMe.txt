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
  
-- ATiM v2.6.8 upgrade
-- -------------------

  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.0_upgrade.sql

-- Demo installation
-- -----------------

  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < atim_v2.7.0_full_installation.sql
  mysql -u {username} -p{password} {atim_database} --default-character-set=utf8 < ./DemoData/atim_v2.7.0_demo_data.sql



-- -------------------------------------------------------------------------------------------------------------------
-- ATiM Migration Details & Actions Items
-- -------------------------------------------------------------------------------------------------------------------

-- v2.7.0
--   See ATiM Version Release Notes 
--      (http://www.ctrnet.ca/mediawiki/index.php/Version_Release_Notes#v2.7.0)
-- ----------------------------------------------------------------------------

   ### 1 # CakePhp version upgrade and Reformating source code
   ----------------------------------------------
 
      ATiM version 2.7.0 is built on the version 2.9.8 of CakePhp. In addition 
      to this upgrade, the source code of ATiM has been reformated to be more compliant 
      with the CakePhp coding standards. 
         (See https://book.cakephp.org/2.0/en/contributing/cakephp-coding-conventions.html)

      TODO:

      In any custom files (see app/Plugin/*/Hook and app/Plugin/*/Custom directory),  
      reformat custom code following the instructions below. Note that all php scripts 
      listed into the instructions are located in '/scripts/v2.7.0/CustomCodeSnifer/'.

         I - Reformat custom code to PSR-2 coding style

              Instruction for eclipse:
                  a. Window>preferences>PHP>Formatter.
                  b. Choose PSR2>OK
                  c. Click on the app folder of project in PHP Explorer
                  d. Press Ctrl+Shift+F.

         II - Replace flash with atimFlashWarning, atimFlashInfo, atimFlashConfirm 
           or atimFlashError

         III - Remove php function deprecated in php 7.0

              Use explode instead of split

         IV - Replace 'else if' with 'elseif'

              Use replacement function in editor (Eclipse or netbeans) to replace 
              regular expression 'else\s\s*if' with 'elseif'

         V - Delete '?>' at the end of pure PHP files (if you don't add --commit option the changes will be logged in a file without effecting the codes)

              Linux or mac:
					php ./CustomCodeSnifer/RemovePhpTagAndSpaceAtTheEndOfFile-custum.php /.../atim/app --commit
			  windows: 
					php CustomCodeSnifer\RemovePhpTagAndSpaceAtTheEndOfFile-custum.php ..\..\app --commit

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
   -----------------------------------------------------

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

      TODO:

      Parse any custom code to apply the same change.
