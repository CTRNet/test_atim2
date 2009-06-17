<?php

class StructureField extends AppModel {

	var $name = 'StructureField';

	var $hasMany = array(
		'StructureValidation'
	);
	
	/*
	var $hasOne = array(
		'StructureValueDomain'	=> array(
			'className'		=> 'StructureValueDomain',
			'foreignKey'	=>	false,
			'finderQuery'	=> '
				SELECT 
					StructureValueDomain.* 
				FROM 
					structure_fields AS StructureField, 
					structure_value_domains AS StructureValueDomain 
				WHERE 
					StructureField.id={$__cakeID__$} 
					AND StructureField.structure_value_domain=StructureValueDomain.domain_name
			'
		)
	);
	*/
	
	var $belongsTo = array(
		'StructureValueDomain'	=> array(
			'className'		=> 'StructureValueDomain',
			'foreignKey'	=>	'structure_value_domain'
		)
	);
	
}

?>