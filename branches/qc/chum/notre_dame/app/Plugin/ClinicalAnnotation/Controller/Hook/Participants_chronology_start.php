<?php

// *** Clinical Exam ***
$labMarkerTypes = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Other Lab Marker Types'
));
$labMarkerTypes = array_merge($labMarkerTypes['defined'], $labMarkerTypes['previously_defined']);
$labMarkerTypes[''] = '';

$geneticTests = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Genetic Tests'
));
$geneticTests = array_merge($geneticTests['defined'], $geneticTests['previously_defined']);
$geneticTests[''] = '';

$labMarkerUnits = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Other Lab Marker Units'
));
$labMarkerUnits = array_merge($labMarkerUnits['defined'], $labMarkerUnits['previously_defined']);
$labMarkerUnits[''] = '';

// *** Diagnosis ***

$icdO3TopoModel = AppModel::getInstance('CodingIcd', 'CodingIcdo3Topo', true);
$icdO3TopoCategories = $icdO3TopoModel::getTopoCategoriesCodes();
