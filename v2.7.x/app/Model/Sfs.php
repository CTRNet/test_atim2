<?php
App::uses('AppModel', 'Model');
/**
 * Sfs stands for Structure Format Simplified
 */
class Sfs extends AppModel {
	var $useTable = 'view_structure_formats_simplified';
	var $name = 'Sfs';
	var $hasMany = array(
        //fetched manually in model/structure
		'StructureValidation' => array('foreignKey' => 'structure_field_id')
	);
	
	var $belongsTo = array(
		'StructureValueDomain'	=> array(
			'className'		=> 'StructureValueDomain',
			'foreignKey'	=>	'structure_value_domain'
		)
	);
}