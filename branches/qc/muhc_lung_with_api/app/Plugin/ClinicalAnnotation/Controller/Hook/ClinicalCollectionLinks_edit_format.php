<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */

// --------------------------------------------------------------------------------
// Collection to participant bank foreign key
// --------------------------------------------------------------------------------

if (false) {
    // Note: Set condition to true when the CUSM team will request
    // to be able to change collection participant identifier
    
    // Set identifier list
    
    $this->MiscIdentifier = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier');
    $miscIdentifierData = $this->MiscIdentifier->find('threaded', array(
        'conditions' => array(
            'MiscIdentifier.participant_id' => $participantId,
            'MiscIdentifierControl.misc_identifier_name' => array(
                'lung bank participant number'
            )
        )
    ));
    $foundMId = false;
    $foundMId = $this->setForRadiolist($miscIdentifierData, 'MiscIdentifier', 'id', $dataForForm, 'Collection', 'misc_identifier_id');
    $this->set('miscIdentifierData', $miscIdentifierData);
    $this->set('foundMId', $foundMId);
    $this->Structures->set('miscidentifiers', 'atim_structure_misc_identifier');
}