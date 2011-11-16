<?php

class StructureValueDomainsPermissibleValue extends AppModel {

	var $name = 'StructureValueDomainsPermissibleValue';

	var $belongsTo = array(        
		'StructurePermissibleValue' => array(            
			'className'    => 'StructurePermissibleValue',            
			'foreignKey'    => 'structure_permissible_value_id'
		)
	);	
}

?>