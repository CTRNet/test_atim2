<?php

class StructureFormat extends AppModel {

	var $name = 'StructureFormat';

	var $belongsTo = array('StructureField');
	
	
	function customSearch(String $conditions, String $order = NULL){
		$query = "SELECT * FROM structure_formats AS StructureFormat "
			."INNER JOIN structure_fields AS StructureField ON StructureFormat.structure_field_id=StructureField.id "
			."INNER JOIN structures AS Structure ON StructureFormat.structure_id=Structure.id ";
		if(strlen($conditions)){
			$query .= "WHERE ".$conditions;
		}
		if(strlen($order)){
			$query .= " ORDER BY ";
		}
		return $this->query($query);
	}
}

?>