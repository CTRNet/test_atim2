<?php
	set_time_limit(100000000000);
	
	$connection = @mysql_connect("localhost", "root", "1qaz1qaz") or die("MySQL connection could not be established");
	
	@mysql_select_db("atim") or die("ATiM database could not be found");
	
	$query = "SELECT * FROM `form_validations`;";
	
	$result = mysql_query($query);
	
	for( $i = 0; $i < mysql_num_rows($result); $i++ ){
		$validation_rule = mysql_result($result, $i, 'expression');
		$field_id = mysql_result($result, $i, 'form_field_id');
		$message = mysql_result($result, $i, 'message');
		
		//print_r($field_id);
		
		$query = "SELECT `id` FROM `structure_fields` WHERE `old_id` = '$field_id';";
		$field_result = mysql_query($query);
		
		$rule = NULL;
		
		if( $field_result == NULL || mysql_fetch_row($field_result) == NULL){
			$rule = NULL;
		}elseif($validation_rule == '/.+/'){
			$rule = 'notEmpty';
			
			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/[a-zA-Z0-9]{5,15}/'){
			$rule = array( 0=>'alphaNumeric', 1=>'between,5,15');
			

			$structure_id = mysql_result($field_result, 0, 'id');
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule[0]', '1', '0', '$message' );";
			mysql_query($query);
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule[1]', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/^\d*([\.]\d*)?$/'){
			$rule = 'decimal';

			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/^-{0,1}\d*([\.]\d*)?$/'){
			$rule = 'decimal';

			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/[A-Za-z]+/'){
			$rule = 'custom,/[A-Za-z]+/';

			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/^(?!err!).*$/'){
			$rule = 'custom,/^(?!err!).*$/';
			
			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/(?(?=^$)|^([0-9]|[1-9][0-9]|1[0-4][0-9])$)/'){
			$rule = 'range,0,150';
			
			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/(?(?=^$)|^([4-9][0-9]|100)$)/'){
			$rule = 'range,40,100';

			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/(?(?=^$)|^([0-9]|1[0-9]|20)$)/'){
			$rule = 'range,0,20';

			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/(?(?=^$)|^([0-9]|[1-4][0-9]|50)$)/'){
			$rule = 'range,0,50';

			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/^\b[0-9]*\.?[0-9]+\b/'){
			$rule = 'decimal';
			
			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}elseif($validation_rule == '/^\d+$/'){
			$rule = 'number';

			$structure_id = mysql_result($field_result, 0, 'id');
			
			$query = "INSERT INTO `structure_validations` ( `structure_field_id`, `rule`, `flag_empty`, `flag_required`, `message` ) VALUES
						( $structure_id, '$rule', '1', '0', '$message' );";
			mysql_query($query);
		}
		
		//print_r($query);
		mysql_query("DROP TABLE `form_validations`;");
	}
?>