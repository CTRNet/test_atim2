<?php
$qcLadyTumorSite = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
    'Tumor Sites'
));
$qcLadyTumorSite = array_merge($qcLadyTumorSite['defined'], $qcLadyTumorSite['previously_defined']);

$imageResponse = $this->StructureValueDomain->find('first', array(
    'conditions' => array(
        'StructureValueDomain.domain_name' => 'response'
    ),
    'recursive' => 2
));
$imageResponseValues = array();
if ($imageResponse) {
    foreach ($imageResponse['StructurePermissibleValue'] as $newValue) {
        $imageResponseValues[$newValue['value']] = __($newValue['language_alias']);
    }
}

$dataTxeProceduresProperties = array(
    'biopsy' => 'Biopsy Procedure',
    'surgery' => 'Surgical Procedure',
    'radiation' => 'Radiation Procedure'
);
$qcLadyTxeProcedures = array();
foreach ($dataTxeProceduresProperties as $txeTypeKey => $customControlName) {
    $qcLadyTxeProcedures[$txeTypeKey] = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
        $customControlName
    ));
    $qcLadyTxeProcedures[$txeTypeKey] = array_merge($qcLadyTxeProcedures[$txeTypeKey]['defined'], $qcLadyTxeProcedures[$txeTypeKey]['previously_defined']);
}

$markersListProperties = array(
    'blood_marker' => 'Blood markers',
    'blood_marker_unit' => 'Blood markers Units',
    'genetic_markers' => 'Genetic Markers',
    'genetic_markers_results' => 'Genetic Marker Results'
);
$qcLadyMarkersDropDownList = array();
foreach ($markersListProperties as $txeTypeKey => $customControlName) {
    $qcLadyMarkersDropDownList[$txeTypeKey] = $this->StructurePermissibleValuesCustom->getCustomDropdown(array(
        $customControlName
    ));
    $qcLadyMarkersDropDownList[$txeTypeKey] = array_merge($qcLadyMarkersDropDownList[$txeTypeKey]['defined'], $qcLadyMarkersDropDownList[$txeTypeKey]['previously_defined']);
}

$protocolFromId = array();
$protcolModel = AppModel::getInstance('Protocol', 'ProtocolMaster', true);
foreach ($protcolModel->find('all') as $newProtocol) {
    $protocolFromId[$newProtocol['ProtocolMaster']['id']] = $newProtocol['ProtocolMaster']['code'];
}

if(!isset($collectionModel)) {
    $collectionModel = AppModel::getInstance('InventoryManagement', 'Collection', true);
}
$qcLadyCollSpecimenTypePrecisions = $collectionModel->getSpecimenTypePrecision();