<?php
$this->MiscIdentifier = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
$conditions = array(
    'MiscIdentifier.deleted' => '0',
    'MiscIdentifier.participant_id' => $participantId,
    "MiscIdentifierControl.misc_identifier_name IN ('Breast bank #', 'Q-CROC-03')"
);
$miscidentifierData = $this->MiscIdentifier->find('all', array(
    'conditions' => $conditions,
    'order' => array(
        'MiscIdentifier.created DESC'
    )
));
$foundMiscIdentifier = false;
if (isset($this->request->data['Collection']['misc_identifier_id'])) {
    $foundMiscIdentifier = $this->setForRadiolist($miscidentifierData, 'MiscIdentifier', 'id', $this->request->data, 'Collection', 'misc_identifier_id');
}
$this->set('miscidentifierData', $miscidentifierData);
$this->set('foundMiscIdentifier', $foundMiscIdentifier);

$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');