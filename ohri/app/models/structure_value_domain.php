<?php

class StructureValueDomain extends AppModel {

	var $name = 'StructureValueDomain';

	var $hasMany = array(
		'StructureValueDomainsPermissibleValue'	=> array(
			'className'		=> 'StructureValueDomainsPermissibleValue',
			'foreignKey'	=>	'structure_value_domain_id'
		)
	);
	
	function afterFind($results){
		if(isset($results['StructureValueDomainsPermissibleValue'])){
			$old_result = $results;
			$results = array(
				"id"			=> $old_result['id'],
				"domain_name"	=> $old_result['domain_name'],
				"overrive"		=> $old_result['override'],
				"category"		=> $old_result['category'],
				"source"		=> $old_result['source']
			);
			$permissible_values = array();
			
			//sort here for 2.1.0B
			$sort = array();
			foreach($old_result['StructureValueDomainsPermissibleValue'] as $index => $svdpv){
				$sort[$index] = sprintf("%04d", $svdpv['display_order']).__($svdpv['StructurePermissibleValue']['language_alias'], true);
			}
			asort($sort);
			foreach(array_keys($sort) as $index){
				$svdpv = $old_result['StructureValueDomainsPermissibleValue'][$index];
				$permissible_values[] = array(
					"id"				=> $svdpv['StructurePermissibleValue']['id'],
					"value"				=> $svdpv['StructurePermissibleValue']['value'],
					"language_alias"	=> $svdpv['StructurePermissibleValue']['language_alias'],
					"Svdpv"				=> array("display_order" => $svdpv['display_order'])
				);
			}
			$results['StructurePermissibleValue'] = $permissible_values;
		}
		return $results;
	}
}

?>