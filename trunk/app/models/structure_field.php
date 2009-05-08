<?php

class StructureField extends AppModel {

	var $name = 'StructureField';

	var $belongsTo = array(
		'StructureValidation',
		'StructureValueDomain'	=> array(
			'className'		=> 'StructureValueDomain',
			'foreignKey'	=>	false,
			'finderQuery'	=> 'SELECT StructureValueDomain.* FROM structure_fields AS StructureField, structure_value_domains AS StructureValueDomain WHERE StructureField.id={$__cakeID__$} AND StructureField.structure_value_domain=StructureValueDomain.domain_name'
		)
	);
	
}

?>