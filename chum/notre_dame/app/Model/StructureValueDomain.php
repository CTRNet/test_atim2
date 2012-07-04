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
			$permissible_values = array();
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
	
	function updateDropdownResult(array $structure_value_domain, &$dropdown_result){
		if(strlen($structure_value_domain['source']) > 0){
			//load source
			$tmp_dropdown_result = StructuresComponent::getPulldownFromSource($structure_value_domain['source']);
			if(array_key_exists('defined', $tmp_dropdown_result)){
				$dropdown_result['defined'] += $tmp_dropdown_result['defined'];
				if(array_key_exists('previously_defined', $tmp_dropdown_result)){
					$dropdown_result['previously_defined'] += $tmp_dropdown_result['previously_defined'];
				}
			}else{
				$dropdown_result['defined'] += $tmp_dropdown_result;
			}
		}else{
			$this->cacheQueries = true;
			$tmp_dropdown_result = $this->find('first', array(
					'recursive' => 2, //cakephp has a memory leak when recursive = 2
					'conditions' => array('StructureValueDomain.id' => $structure_value_domain['id'])));
			if(isset($tmp_dropdown_result['StructurePermissibleValue']) && count($tmp_dropdown_result['StructurePermissibleValue']) > 0){
				$tmp_result = array('defined' => array(), 'previously_defined' => array());
				//sort based on flag and on order
				foreach($tmp_dropdown_result['StructurePermissibleValue'] as $tmp_entry){
					if($tmp_entry['flag_active']){
						if($tmp_entry['use_as_input']){
							$tmp_result['defined'][$tmp_entry['value']] = sprintf("%04d", $tmp_entry['display_order']).__($tmp_entry['language_alias'], true);
						}else{
							$tmp_result['previously_defined'][$tmp_entry['value']] = sprintf("%04d", $tmp_entry['display_order']).__($tmp_entry['language_alias'], true);
						}
					}
				}
				asort($tmp_result['defined']);
				asort($tmp_result['previously_defined']);
				$substr4_func = create_function('$str', 'return substr($str, 4);');
				$tmp_result['defined'] = array_map($substr4_func, $tmp_result['defined']);
				$tmp_result['previously_defined'] = array_map($substr4_func, $tmp_result['previously_defined']);
		
				$dropdown_result['defined'] += $tmp_result['defined'];//merging arrays and keeping numeric keys intact
				$dropdown_result['previously_defined'] += $tmp_result['previously_defined'];
			}
		}
	}
}

?>