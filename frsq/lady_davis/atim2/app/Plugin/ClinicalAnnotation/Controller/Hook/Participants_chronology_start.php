<?php
	
$qc_lady_tumor_site = $this->StructurePermissibleValuesCustom->getCustomDropdown(array('Tumor Sites'));
$qc_lady_tumor_site = array_merge($qc_lady_tumor_site['defined'],$qc_lady_tumor_site['previously_defined']);

$image_response = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => 'response'), 'recursive' => 2));
$image_response_values = array();
if($image_response) {
	foreach($image_response['StructurePermissibleValue'] as $new_value) {
		$image_response_values[$new_value['value']] = __($new_value['language_alias']);
	}
}