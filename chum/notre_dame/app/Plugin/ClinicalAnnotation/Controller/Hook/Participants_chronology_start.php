<?php

// *** Clinical Exam ***
$lab_marker_types = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Other Lab Marker Types'
));
$lab_marker_types = array_merge($lab_marker_types['defined'], $lab_marker_types['previously_defined']);
$lab_marker_types[''] = '';

$genetic_tests = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Genetic Tests'
));
$genetic_tests = array_merge($genetic_tests['defined'], $genetic_tests['previously_defined']);
$genetic_tests[''] = '';

$lab_marker_units = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Other Lab Marker Units'
));
$lab_marker_units = array_merge($lab_marker_units['defined'], $lab_marker_units['previously_defined']);
$lab_marker_units[''] = '';

$estrogen_progestin_receptor_results = $this->Participant->getSardoValues(array(
    'SARDO : Estrogen/Progestin Receptor Results'
));
$estrogen_progestin_receptor_results[''] = '';

$her2_neu_results = $this->Participant->getSardoValues(array(
    'SARDO : HER2/NEU Results'
));
$her2_neu_results[''] = '';

// *** Diagnosis ***

$icd_o_3_topo_model = AppModel::getInstance('CodingIcd', 'CodingIcdo3Topo', true);
$icd_o_3_topo_categories = $icd_o_3_topo_model::getTopoCategoriesCodes();

$sardo_progression_details = $this->Participant->getSardoValues(array(
    'SARDO : Progression Details'
));
$sardo_progression_details[''] = '';
	