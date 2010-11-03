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
					structure_value_domains,
					structure_value_domains_permissible_values,
					structure_permissible_values AS StructurePermissibleValue 
				WHERE 
					structure_value_domains.id={$__cakeID__$} 
					AND structure_value_domains.id=structure_value_domains_permissible_values.structure_value_domain_id
					AND structure_value_domains_permissible_values.flag_active="1"
					AND structure_value_domains_permissible_values.structure_permissible_value_id=StructurePermissibleValue.id
				ORDER BY
					structure_value_domains_permissible_values.display_order ASC
				'
		)
	);
	
}

?>