<?php
$this->MiscIdentifier = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
$this->MiscIdentifier->bindModel(array(
    'hasMany' => array(
        'Collection' => array(
            'className' => 'Collection',
            'foreignKey' => 'misc_identifier_id'
        )
    )
));
$conditions = array(
    'MiscIdentifier.deleted' => '0',
    'MiscIdentifier.participant_id' => $participantId,
    "MiscIdentifierControl.misc_identifier_name IN ('patient study id', 'ohri_ovary_bank_participant_id')"
);
$miscidentifierData = $this->MiscIdentifier->find('all', array(
    'conditions' => $conditions,
    'order' => array(
        'MiscIdentifier.created DESC'
    )
));
$foundMiscIdentifier = false;

foreach ($miscidentifierData as &$identifier) {
    foreach ($identifier['Collection'] as $unit) {
        if ($unit['id'] == $collectionId) {
            // we found the one that interests us
            $identifier['Collection'] = $unit;
            $foundMiscIdentifier = true;
            break;
        }
    }
    
    if ($foundMiscIdentifier) {
        break;
    }
}

$this->set('miscidentifierData', $miscidentifierData);
$this->set('foundMiscIdentifier', $foundMiscIdentifier);

$this->Structures->set('miscidentifiers', 'atim_structure_miscidentifier_detail');