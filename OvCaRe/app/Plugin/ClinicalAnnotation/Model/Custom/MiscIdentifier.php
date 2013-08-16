<?php

class MiscIdentifierCustom extends MiscIdentifier {
	var $name = 'MiscIdentifier';
	var $useTable = 'misc_identifiers';
	
	function getNextLabId() {
		$sql = "
			SELECT max(res.formatted_identifier_value) as max_formatted_identifier_value FROM (
				SELECT identifier_value, REPLACE(identifier_value, 'DAH', '000') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DAH[1-9][a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1 
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DAH', '00') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DAH[1-9][0-9][a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1  
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DAH', '0') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DAH[1-9][0-9]{2}[a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1   
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DAH', '') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DAH[1-9][0-9]{3}[a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1   
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DAH', '') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DAH[0-9]{4}[a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1   
				UNION
				SELECT identifier_value, REPLACE(identifier_value, 'DG', '000') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DG[1-9][a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1 
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DG', '00') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DG[1-9][0-9][a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1  
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DG', '0') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DG[1-9][0-9]{2}[a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1   
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DG', '') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DG[1-9][0-9]{3}[a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1   
				UNION 
				SELECT identifier_value, REPLACE(identifier_value, 'DG', '') AS formatted_identifier_value FROM misc_identifiers WHERE identifier_value regexp '^DG[0-9]{4}[a-zA-Z]{0,1}$' AND misc_identifier_control_id = 4 AND deleted <> 1   
			) AS res;";		
		$res = $this->query($sql);	
		if($res && $res[0][0]['max_formatted_identifier_value']) {
			preg_match('/^0*([1-9][0-9]{0,3})[a-zA-Z]{0,1}$/', $res[0][0]['max_formatted_identifier_value'], $matches);		
			$last_val = $matches[1];
			$last_val++;
			return $last_val;
		}
		return 1;
	}
}

