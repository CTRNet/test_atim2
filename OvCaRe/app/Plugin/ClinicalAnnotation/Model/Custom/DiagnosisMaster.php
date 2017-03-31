<?php

class DiagnosisMasterCustom extends DiagnosisMaster {
	var $name = 'DiagnosisMaster';
	var $useTable = 'diagnosis_masters';
	//***********************************************************************************************************************
	//TODO Ying Request To Validate
	//***********************************************************************************************************************	
// 	private $structure_fields_data_for_validation = array();
	
// 	function validateDxCsvFileDataSubmitted($csv_data, $structure_aliases, $validate_date = true) {
		
// 		// BUILD ARRAY OF FIELD TYPES AND LIST OF ALLOWED VALUES			
		
// 		if(!array_key_exists($structure_aliases, $this->structure_fields_data_for_validation)) {
// 			if(strlen($structure_aliases)) {
// 				$fields_properties = $this->tryCatchQuery("SELECT model, field, type, structure_value_domain_name, source, language_label, language_tag
// 					FROM view_structure_formats_simplified
// 					LEFT JOIN structure_value_domains sd ON structure_value_domain = sd.id
// 					WHERE structure_alias IN ('".str_replace(',', "','", $structure_aliases)."')
// 					AND flag_addgrid = 1
// 					AND type IN ('select', 'date', 'yes_no')");
// 				App::uses('StructureValueDomain', 'Model');
// 				$this->StructureValueDomain = new StructureValueDomain();
// 				App::uses('StructurePermissibleValuesCustom', 'Model');
// 				$this->StructurePermissibleValuesCustom = new StructurePermissibleValuesCustom();
// 				foreach($fields_properties as $field_property) {
// 					$field_language = implode(' ', array_filter(array('language_label' => $field_property['view_structure_formats_simplified']['language_label'], 'language_tag' => $field_property['view_structure_formats_simplified']['language_tag'])));
// 					$values = null;
// 					$translated_values = null;
// 					if($field_property['view_structure_formats_simplified']['type'] == 'select') {
// 						if(empty($field_property['sd']['source'])) {
// 							$domains_values = $this->StructureValueDomain->find('first', array('conditions' => array('StructureValueDomain.domain_name' => $field_property['view_structure_formats_simplified']['structure_value_domain_name']), 'recursive' => 2));
// 							foreach($domains_values['StructurePermissibleValue'] as $new_value) {
// 								$values[strtolower($new_value['value'])] = $new_value['value'];
// 								$translated_values[strtolower(__($new_value['value']))] = $new_value['value'];
// 							}
// 						} else {
// 							if(preg_match("/^StructurePermissibleValuesCustom::getCustomDropdown\('(.*)'\)$/", $field_property['sd']['source'], $matches)) {
// 								$domains_values = $this->StructurePermissibleValuesCustom->getCustomDropdown(array($matches[1]));
// 								$domains_values = array_merge($domains_values['defined'], $domains_values['previously_defined']);
// 								foreach($domains_values as $new_value => $translated_value) {
// 									$values[strtolower($new_value)] = $new_value;
// 									$translated_values[strtolower($translated_value)] = $new_value;
// 								}
// 							}
// 						}
// 					}
// 					$this->structure_fields_data_for_validation[$structure_aliases][$field_property['view_structure_formats_simplified']['model']][$field_property['view_structure_formats_simplified']['field']] = array($field_property['view_structure_formats_simplified']['type'], $field_language, $values, $translated_values);	
// 				}
// 			}			
// 		}
		
// 		// LAUNCH VALIDATION
		
// 		$validation_errors = array();
// 		foreach($csv_data as $model => $fields_data) {
// 			foreach($fields_data as $field => $value) {
// 				$value = trim($value);
// 				if(strlen($value) && isset($this->structure_fields_data_for_validation[$structure_aliases][$model][$field])) {
// 					$wrong_format = false;
// 					list($field_type, $field_language, $field_values, $translated_field_values) = $this->structure_fields_data_for_validation[$structure_aliases][$model][$field];
// 					switch($field_type) {
// 						case 'date':
// 							if($validate_date && !preg_match('/^[0-9]{4}(-[0-9]{2}){0,1}(-[0-9]{2}){0,1}$/', $value)) {
// 								$wrong_format = true;
// 							}
// 							break;
// 						case 'yes_no':
// 							switch(strtolower($value)) {
// 								case 'yes':
// 								case 'y':
// 								case '1':
// 									$value = 'y';
// 									break;
// 								case 'no':
// 								case 'n':
// 								case '0':
// 									$value = 'n';
// 									break;
// 								default:
// 									$wrong_format = true;
// 							}
// 							break;
// 						case 'select':
// 							if(array_key_exists(strtolower($value), $field_values)) {
// 								$value = $field_values[strtolower($value)];
// 							} else if(array_key_exists(strtolower($value), $translated_field_values)) {
// 									$value = $translated_field_values[strtolower($value)];
// 							} else {
// 								$wrong_format = true;
// 							}
// 							break;
// 					}
// 					if($wrong_format) $validation_errors[$field] = str_replace('%s', $value,  __('value [%s] is not value supported'))." (".__($field_language).")";
// 					$csv_data[$model][$field] = $value;
// 				}
// 			}
// 		}
		
// 		return array($csv_data, $validation_errors);
// 	}
	//***********************************************************************************************************************
	//TODO End Ying Request To Validate
	//***********************************************************************************************************************
}
?>