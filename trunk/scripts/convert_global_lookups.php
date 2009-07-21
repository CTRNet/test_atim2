<?php
	// Takes the atim.global_lookups table and use the unique alias entries to populate the structure_value_domains and takes the unique values from
	// global_lookups and populates the structure_permissible_values table. Then it populates structure_value_domain_permissible_values with the appropriate
	// ids from structure_value_domains and structure_permissible_values tables.
	// TO DO: populate the structure_fields' value_domain_id with the appropriate structure_value_domains' id 
	set_time_limit(10000000000);
	
	//Establish connection
	$connection = @mysql_connect("localhost", "root", "1qaz1qaz") or die("MySQL connection could not be established");
	
	//Selects database
	@mysql_select_db("atim") or die("ATiM database could not be found");
	
	$query = "SELECT f.id, f.model, f.`field`, g.alias, g.`value`, g.display_order, g.language_choice, g.active
				FROM form_fields f, global_lookups g, form_fields_global_lookups fg
				WHERE f.id = fg.field_id AND fg.lookup_id = g.id
				ORDER BY f.model, f.`field`;";
	$result = mysql_query($query);
	
	$id = 0;
	
	for($i = 0; $i < mysql_num_rows($result); $i++){
		$data_array[$i] = array('field_id' => '', 'alias' => '', 'value' => array(), 'lang_choice'=> array(), 'active' => array(), 'display_order' => array());
	
		$exists = array( 'bool' => false, 'num' => 0 );
		
		for( $j = 0; $j < count($data_array); $j++){
			
			if( $data_array[$j]['field_id'] === mysql_result($result, $i, 'f.id') ){
				$exists['bool'] = true;
				$exists['num'] = $j;
				break;
			}
		}
		
		if($exists['bool'] == true){
			$data_array[$exists['num']]['alias'] = mysql_result($result, $i, 'g.alias');
			$data_array[$exists['num']]['value'][count($data_array[$exists['num']]['value'])] = mysql_result($result, $i, 'g.value');
			$data_array[$exists['num']]['lang_choice'][count($data_array[$exists['num']]['lang_choice'])] = mysql_result($result, $i, 'g.language_choice');
			$data_array[$exists['num']]['active'][count($data_array[$exists['num']]['active'])] = mysql_result($result, $i, 'g.active');
			$data_array[$exists['num']]['display_order'][count($data_array[$exists['num']]['display_order'])] = mysql_result($result, $i, 'g.display_order');
		}else{
			$data_array[$id]['field_id'] = mysql_result($result, $i, 'f.id');
			$data_array[$id]['alias'] = mysql_result($result, $i, 'g.alias');
			$data_array[$id]['value'][0] = mysql_result($result, $i, 'g.value');
			$data_array[$id]['lang_choice'][0] = mysql_result($result, $i, 'g.language_choice');
			$data_array[$id]['active'][0] = mysql_result($result, $i, 'g.active');
			$data_array[$id]['display_order'][0] = mysql_result($result, $i, 'g.display_order');
			
			$id++;
		}
	}
	
	print_r($data_array);
	
	$count = 0;
	for( $i = 0; $i < count($data_array); $i++ ){
		if( $data_array[$i]['field_id'] != ''){
			$alias = $data_array[$i]['alias'];
			$query = "INSERT INTO `structure_value_domains` SET `id` = $i, `domain_name` = '$alias';";
			mysql_query($query);
		
			$field_id = $data_array[$i]['field_id'];
			$query = "UPDATE `structure_fields` SET `structure_value_domain` = $i WHERE `old_id` = '$field_id';";
			mysql_query($query);
		
			for( $j = 0; $j < count($data_array[$i]['value']) ; $j++){
				$count++;
				
				$value = $data_array[$i]['value'][$j];
				$lang_alias = $data_array[$i]['lang_choice'][$j];
				$query = "INSERT INTO `structure_permissible_values` SET `id` = $count, `value` = '$value', `language_alias` = '$lang_alias';";
				mysql_query($query);
				
				
				$display_order = $data_array[$i]['display_order'][$j];
				$active = $data_array[$i]['active'][$j];
				$query = "INSERT INTO `structure_value_domains_permissible_values` SET `structure_value_domain_id` = $i, `structure_permissible_value_id` = $count, 
								`display_order` = $display_order, `active` = '$active';";
				mysql_query($query);
			}
		}
	}
	
?>