<?php

class StructureValueDomain extends AppModel {

	var $name = 'StructureValueDomain';

	var $hasMany = array(
		'StructurePermissibleValue'	=> array(
			'className'		=> 'StructurePermissibleValue',
			'foreignKey'	=>	false,
			'finderQuery'	=> '
				SELECT 
					StructurePermissibleValue.* 
				FROM 
					structure_value_domains AS StructureValueDomain,
					structure_value_domains_permissible_values,
					structure_permissible_values AS StructurePermissibleValue 
				WHERE 
					StructureValueDomain.id={$__cakeID__$} 
					AND StructureValueDomain.id=structure_value_domains_permissible_values.structure_value_domain_id
					AND structure_value_domains_permissible_values.structure_permissible_value_id=StructurePermissibleValue.id
					AND structure_value_domains_permissible_values.active="yes"
				ORDER BY
					structure_value_domains_permissible_values.display_order ASC
				'
		)
	);
	
}

?>