<?php

class StructureValueDomain extends AppModel {

	var $name = 'StructureValueDomain';

	var $hasMany = array(
		'StructureValueDomainsPermissibleValue'	=> array(
			'className'		=> 'StructureValueDomainsPermissibleValue',
			'foreignKey'	=>	'structure_value_domain_id'
		)
	);
	
	public function afterFind($results, $primary = false){
		if(isset($results[0])){
			foreach($results as &$sub_result){		
				if(isset($sub_result['StructureValueDomainsPermissibleValue'])){
					$old_result = $sub_result;
					$svd = $old_result['StructureValueDomain'];
					$sub_result = array(
						"id"			=> $svd['id'],
						"domain_name"	=> $svd['domain_name'],
						"overrive"		=> $svd['override'],
						"category"		=> $svd['category'],
						"source"		=> $svd['source']
					);
					$permissible_values = array();
					foreach($old_result['StructureValueDomainsPermissibleValue'] as $svdpv){
						$permissible_values[] = array(
							"id"				=> $svdpv['id'],
							"value"				=> $svdpv['StructurePermissibleValue']['value'],
							"language_alias"	=> $svdpv['StructurePermissibleValue']['language_alias'],
							"display_order"		=> $svdpv['display_order'],
							"flag_active"		=> $svdpv['flag_active'],
							"use_as_input"		=> $svdpv['use_as_input'],
						);
					}
					$sub_result['StructurePermissibleValue'] = $permissible_values;
				}else{
					break;
				}
			}
			$results['StructurePermissibleValue'] = $permissible_values;
		}
		return $results;
	}
}

?>