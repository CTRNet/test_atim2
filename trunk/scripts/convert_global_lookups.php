<?php
	// Takes the global_lookups table and use the unique alias entries to populate the structure_value_domains and takes the unique values from
	// global_lookups and populates the structure_permissible_values table. Then it populates structure_value_domain_permissible_values with the appropriate
	// ids from structure_value_domains and structure_permissible_values tables.
	// TO DO: populate the structure_fields' value_domain_id with the appropriate structure_value_domains' id 
	set_time_limit(10000000000);
	
	//Establish connection
	$connection = @mysql_connect("localhost", "root", "1qaz1qaz") or die("MySQL connection could not be established");
	
	//Selects database
	@mysql_select_db("atim2") or die("ATiM database could not be found");
	
	//Grab nessecary values 
	$query = "SELECT DISTINCT `value`, language_choice FROM global_lookups;";
	$result = mysql_query($query);
	
	$value = array( 0 => 0 );
	$language = array( 0 => 0 );
	
	//Splits the results into values and languages
	for($c = 0; $c < mysql_numrows($result); $c++){
		$value[$c] = mysql_result($result, $c, "value");
		$language[$c] = mysql_result($result, $c, "language_choice");
	}
	
	//Clears the structure_permissible_values table
	mysql_query("DELETE FROM `structure_permissible_values");
	
	//Update the structure_permissible_values table with the values from global_lookup table
	for($i = 0; $i < count($value); $i++){
		//Populates the value abd language alias fields in the permissible values table
		$query = "INSERT INTO `structure_permissible_values` SET `value` = '$value[$i]', `language_alias` = '$language[$i]';";
		mysql_query($query);
	}
	
	//Gets all the unique alias' from the global lookups table
	$query = "SELECT DISTINCT alias FROM global_lookups;";
	$result = mysql_query($query);
	
	$alias = array( 0 => 0 );
	
	//Take the results alias's and put them into an array
	for($j = 0; $j < mysql_numrows($result); $j++){
		$alias[$j] = mysql_result($result, $j, "alias");
	}
	
	//Clear the structure_value_domains
	mysql_query("DELETE FROM `structure_value_domains`;");
	
	//Populates the value domain table's domain_name field with the alias values
	for($p = 0; $p < mysql_numrows($result); $p++){
		$query = "INSERT INTO `structure_value_domains` SET domain_name = '$alias[$p]'";
		mysql_query($query);
	}
	
	mysql_query("ALTER TABLE `structure_value_domains_permissible_values` ADD COLUMN `lang_alias` VARCHAR(255) NOT NULL;");
	
	//Gets the ids from the value domain table's id and the permissible value table's id that correspond to the same entry in the global lookups table
	$query = "SELECT d.id, p.id, g.display_order, g.language_choice FROM `global_lookups` g, `structure_permissible_values` p, `structure_value_domains` d 
				WHERE d.domain_name = g.alias AND p.`value` = g.`value`;";
	$result = mysql_query($query);
	
	//Populates the structure_value_domain_permissible_values with the appropriate ids so it can be looked up by atim2 program
	for($s = 0; $s < mysql_numrows($result); $s++){
		$did = mysql_result($result, $s, "d.id");
		$pid = mysql_result($result, $s, "p.id");
		$disorder = mysql_result($result, $s, "g.display_order");
		$lang = mysql_result($result, $s, "g.language_choice");
		$query = "INSERT INTO `structure_value_domains_permissible_values` ( `structure_value_domain_id`, `structure_permissible_value_id`, `display_order`, `active`, `lang_alias` ) VALUES
		( '$did', '$pid', $disorder, 'yes', '$lang') ;";
		mysql_query($query);
	}
	
	//Populates the structure fields table's structure_value_domain_id with the appropriate id
	$query = "SELECT f.id as FID, v.id as VID FROM `structure_fields` f, `form_fields_global_lookups` l, `global_lookups` g, `structure_value_domains` v WHERE l.`field_id` = f.`old_id` AND l.`lookup_id` = g.`id` AND g.`alias` = v.`domain_name` GROUP BY v.`domain_name`;";
	$result = mysql_query($query); 
	
	for($e = 0; $e < mysql_numrows($result); $e++ ) {
		$fid = mysql_result($result, $e, "FID");
		$vid = mysql_result($result, $e, "VID");

		$query = "UPDATE `structure_fields` f SET  f.`structure_value_domain` = '$vid' WHERE f.id = $fid;";
		mysql_query($query);
	}	
?>