<?php

class StructureValueDomain extends AppModel {

	var $name = 'StructureValueDomain';

	var $hasMany = array(
		'StructurePermissibleValue'	=> array(
			'className'		=> 'StructurePermissibleValue',
			'foreignKey'	=>	false,
			'finderQuery'	=> '
				SELECT 
					StructurePermissibleValue.*, display_order
				FROM 
					structure_value_domains,
					structure_value_domains_permissible_values AS Svdpv,
					structure_permissible_values AS StructurePermissibleValue 
				WHERE 
					structure_value_domains.id={$__cakeID__$} 
					AND structure_value_domains.id=Svdpv.structure_value_domain_id
					AND Svdpv.flag_active="1"
					AND Svdpv.structure_permissible_value_id=StructurePermissibleValue.id
				ORDER BY
					Svdpv.display_order ASC
				'
		)
	);
	
}

?>