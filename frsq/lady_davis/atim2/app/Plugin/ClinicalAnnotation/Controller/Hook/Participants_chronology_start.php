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

$protocolFromId = array();
$protcolModel = AppModel::getInstance('Protocol', 'ProtocolMaster', true);
foreach ($protcolModel->find('all') as $newProtocol)
    $protocolFromId[$newProtocol['ProtocolMaster']['id']] = $newProtocol['ProtocolMaster']['code'];

$treatmentExtendModel = AppModel::getInstance('ClinicalAnnotation', 'TreatmentExtendMaster', true);