<?php
//Sfs stands for Structure Format Simplified
class Sfs extends AppModel {
	var $useTable = 'view_structure_formats_simplified';
	var $name = 'Sfs';
	
	var $hasMany = array(
		'StructureValidation'
	);
	
	var $belongsTo = array(
		'StructureValueDomain'	=> array(
			'className'		=> 'StructureValueDomain',
			'foreignKey'	=>	'structure_value_domain'
		)
	);
}

?>