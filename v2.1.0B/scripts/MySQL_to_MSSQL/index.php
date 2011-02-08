<?php

    $f_mysql = @fopen("./mysql201b.sql","r");
    $f_mssql = fopen("./mssql201b.sql","a");
    
    if (!$f_mysql) die("Impossible d'ouvrir le fichier");
    
    $i = 1;

 	$doublon_check = false;   
 	$continue = true;
 	$table_name = '';
 	$array_tables = array();
 	$writte = false;
 	$db_mysql_name = 'atim_210a';
 	$db_mysql_name = 'v210b'; 	
 	
 	
$array_with_data = array(
'aliquot_controls',
'aliquot_review_controls',
'announcements',
'aros',
'aros_acos',
'banks',
'coding_icd10_ca',
'coding_icd10_who',
'coding_icd_o_3_morphology',
'coding_icd_o_3_topography',
'configs',
'consent_controls',
'datamart_batch_processes',
'datamart_browsing_controls',
'datamart_reports',
'datamart_structures',
'diagnosis_controls',
'event_controls',
'external_links',
'groups',
'i18n',
'key_increments',
'menus',
'pages',
'parent_to_derivative_sample_controls',
'protocol_controls',
'realiquoting_controls',
'sample_controls',
'sample_to_aliquot_controls',
'sop_controls',
'specimen_review_controls',
'storage_controls',
'structure_fields',
'structure_formats',
'structure_permissible_values',
'structure_permissible_values_custom_controls',
'structure_permissible_values_customs',
'structure_validations',
'structure_value_domains',
'structure_value_domains_permissible_values',
'structures',
'tx_controls',
'users',
'versions');
 	
 	
 	
 	
    while (!feof($f_mysql) && $continue ) {
        $ligne = fgets($f_mysql, 1024);
		      
		if(strpos($ligne, 'view_aliquots')) {
			$continue = false;
			break;
		}
      	
		// Get table list and autoicnrement field
		$pattern = '/CREATE TABLE (.*) \(/';
        if(preg_match($pattern, $ligne, $matches)) {
        	$writte = true;
        	$table_name = $matches[1];
        	$array_tables[$table_name] = array();     	
        }
        
        //) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=517 ;
		//);
        if(strpos($ligne, "ENGINE=")) {
        	$ligne = ');';
        }
        
        //AUTO_INCREMENT,
  		//
  		 // id int(11) NOT NULL AUTO_INCREMENT,
    	$pattern = '/\s*(.*) \s*int\([0-9]*\).*AUTO_INCREMENT.*/';
        if(preg_match($pattern, $ligne, $matches)) {
        	$array_tables[$table_name][$matches[1]] = 'autoincrement';	
        }
        $ligne =  str_replace("AUTO_INCREMENT", (in_array($table_name, $array_with_data)? "": "IDENTITY"), $ligne);

		 //unsigned,
  		//
		$ligne =  str_replace("unsigned", "", $ligne);
		
        //id int(10) NOT NULL AUTO_INCREMENT,
  		//id int NOT NULL,     
        $ligne =  preg_replace('/int\([0-9]*\)/', 'int', $ligne);
        
        //enum('block','cell gel matrix','core','slide','tube','whatman paper') NOT NULL COMMENT 'Generic name.',
        //varchar(30) NOT NULL DEFAULT '',
        $motif = "enum('block','cell gel matrix','core','slide','tube','whatman paper') NOT NULL COMMENT 'Generic name.',";
		$new = "varchar(30) NOT NULL DEFAULT '',";
        $ligne =  str_replace($motif, $new, $ligne);
        
        //enum('specimen','derivative')
        //varchar(30)
        $motif = "enum('specimen','derivative')";
		$new = "varchar(30)";
        $ligne =  str_replace($motif, $new, $ligne);       
        
        // supra-ordinate_term
        //supra_ordinate_term
        $ligne =  str_replace('supra-ordinate_term', 'supra_ordinate_term', $ligne);
        
        //enum('all','block','cell gel matrix','core','slide','tube','whatman paper')
        //varchar(30),
        $motif = "enum('all','block','cell gel matrix','core','slide','tube','whatman paper')";
		$new = "varchar(30)";
        $ligne =  str_replace($motif, $new, $ligne);

        //enum('alphabetical','integer','list')
        //varchar(30),
        $motif = "enum('alphabetical','integer','list')";
		$new = "varchar(30)";
        $ligne =  str_replace($motif, $new, $ligne);
        
        
        //enum('12','24')
        //tinyint
        $motif = "enum('12','24')";
		$new = "tinyint";
        $ligne =  str_replace($motif, $new, $ligne);
        
        //enum('detail','index')
        //varchar(30),
        $motif = "enum('detail','index')";
		$new = "varchar(30)";
        $ligne =  str_replace($motif, $new, $ligne);        
           
        
        //enum('dropdown','textual')
        //varchar(30),
        $motif = "enum('dropdown','textual')";
		$new = "varchar(30)";
        $ligne =  str_replace($motif, $new, $ligne);           
        
        // set('extend','locked','open')
        //varchar(30),
        $motif = " set('extend','locked','open')";
		$new = "varchar(30)";
        $ligne =  str_replace($motif, $new, $ligne);           
		
 		//`
        //
        $ligne =  preg_replace('/`/', '', $ligne);

        //time stamp
         $motif = "attempt_time timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,";
		$new = "attempt_time datetime NOT NULL CONSTRAINT attempt_time_cts DEFAULT CURRENT_TIMESTAMP,";
        $ligne =  str_replace($motif, $new, $ligne);          
        
        
        $motif = "visited timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,";
		$new = "visited datetime NOT NULL CONSTRAINT visited_cts DEFAULT CURRENT_TIMESTAMP,";
        $ligne =  str_replace($motif, $new, $ligne);            
        
        $motif = "date_installed timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,";
		$new = "date_installed datetime NOT NULL CONSTRAINT date_installed_cts DEFAULT CURRENT_TIMESTAMP,";
        $ligne =  str_replace($motif, $new, $ligne);      
        
        //3_to_20percent_Ki67_positive_cells
        //[3_to_20percent_Ki67_positive_cells]
        $motif = "3_to_20percent_Ki67_positive_cells";
		$new = "[3_to_20percent_Ki67_positive_cells]";
        $ligne =  str_replace($motif, $new, $ligne);         
        
        //von_hippel-Lindau_disease
        //[von_hippel-Lindau_disease]
        $motif = "von_hippel-Lindau_disease";
		$new = "[von_hippel-Lindau_disease]";
        $ligne =  str_replace($motif, $new, $ligne);           
        
        
        //zollinger-Ellison_syndrome
        //[zollinger-Ellison_syndrome]
        $motif = "zollinger-Ellison_syndrome";
		$new = "[zollinger-Ellison_syndrome]";
        $ligne =  str_replace($motif, $new, $ligne); 
        
		//procedure varchar
        //[procedure] varchar
        $motif = '/\sprocedure\s*varchar/';
		$new = '[procedure] varchar';
        $ligne =  preg_replace($motif, $new, $ligne);

        //function varchar
        //[function] varchar
        $motif = '/function\s*varchar/';
		$new = '[function] varchar';
        $ligne =  preg_replace($motif, $new, $ligne);

        //order int
        //[order] int
        $motif = '/\sorder\s*int/';
		$new = '[order] int';
        $ligne =  preg_replace($motif, $new, $ligne);
        
         //default varchar
        //[default] varchar
        $motif = '/default\s*varchar/';
		$new = '[default] varchar';
        $ligne =  preg_replace($motif, $new, $ligne);

         //rule text
        //[rule] text
        $motif = '/rule\s*text/';
		$new = '[rule] text';
        $ligne =  preg_replace($motif, $new, $ligne);
        
        //override set('extend','locked','open')
        $motif = "/override\s*varchar/";
		$new = '[override] varchar';
        $ligne =  preg_replace($motif, $new, $ligne);        
          
         //primary varchar
        //[primary] varchar
        $motif = '/primary\s*varchar/';
		$new = '[primary] varchar';
        $ligne =  preg_replace($motif, $new, $ligne);

        
        //enum(',','.')
        //varchar(30),
        $motif = "enum(',','.')";
		$new = "varchar(10)";
        $ligne =  str_replace($motif, $new, $ligne);              
        
        //COMMENT
        //,
        $ligne =  preg_replace('/COMMENT .*,/', ',', $ligne);
  
        //blob
        $ligne =  str_replace('blob,', 'text,', $ligne);             
        
       	//Key Management
        if(strpos($ligne, "KEY ")) {
        	
        	//  PRIMARY KEY (id),
        	if(strpos($ligne, "PRIMARY KEY")) {
        		$ligne =  str_replace("),", ")", $ligne);
        		
        	//KEY acos_idx1 (lft,rght),
	        //TODO  
        	} else {
        		$ligne = '';
        	}     	
        }

       if($writte) fputs($f_mssql, $ligne);
    }
    
    $array_tables['view_aliquots'] = array();
    $array_tables['view_collections'] = array();
        $array_tables['view_samples'] = array();
        $array_tables['view_structures'] = array();
        
    
    echo "create table done<br>";
    foreach($array_with_data as $rrr => $table_name) {
    	fputs($f_mssql, "INSERT INTO $table_name SELECT * FROM openquery(MYSQL, 'SELECT * FROM $db_mysql_name.$table_name');\n");
    	
    }    
//    foreach($array_tables as $table_name => $autincrements) {
//    	fputs($f_mssql, "INSERT INTO $table_name SELECT * FROM openquery(MYSQL, 'SELECT * FROM $db_mysql_name.$table_name');\n");
//    	
//    }
    fputs($f_mssql, "\n");
    echo "create select insert done<br>";
    
//     foreach($array_tables as $table_name => $autincrements) {
//     	 foreach($autincrements as $field => $tmp) {
//    		fputs($f_mssql, "ALTER TABLE $table_name ALTER COLUMN $field ADD CONSTRAINT IDENTITY;\n");
//     	 }
//    }
    
    echo "create IDENTITY done<br>";   

    fclose($f_mssql);
    fclose($f_mysql);
?> 