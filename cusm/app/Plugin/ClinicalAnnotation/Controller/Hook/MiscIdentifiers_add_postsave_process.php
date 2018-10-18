<?php
/** **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
// --------------------------------------------------------------------------------
// Save Participant Identifier
// --------------------------------------------------------------------------------
switch ($controls['MiscIdentifierControl']['misc_identifier_name']) {
    case 'lung bank participant number':
        $createdMiscIdentifierId = $this->MiscIdentifier->getLastInsertId();
        $queryToUpdate = "UPDATE misc_identifiers SET identifier_value = '" . str_replace('%%YY%%', DATE('y'), $this->request->data['MiscIdentifier']['identifier_value']) . "' WHERE id = $createdMiscIdentifierId;";
        $this->MiscIdentifier->tryCatchQuery($queryToUpdate);
        $this->MiscIdentifier->tryCatchQuery(str_replace("misc_identifiers", "misc_identifiers_revs", $queryToUpdate));
        break;
}

// --------------------------------------------------------------------------------
// Set next kidney bank identifier
// --------------------------------------------------------------------------------
if ($_SESSION['cusm_next_identifier_controls']) {
    $nextIdentifierName = array_shift($_SESSION['cusm_next_identifier_controls']);
    if ($nextIdentifierName) {
        $miscIdentifierControlId = $this->MiscIdentifierControl->find('first', array(
            'conditions' => array(
                'MiscIdentifierControl.misc_identifier_name' => $nextIdentifierName,
                'MiscIdentifierControl.flag_active' => 1
            )
        ));
        if ($miscIdentifierControlId) {
            $miscIdentifierControlId = $miscIdentifierControlId['MiscIdentifierControl']['id'];
            $urlToFlash = "/ClinicalAnnotation/MiscIdentifiers/add/$participantId/$miscIdentifierControlId";
            $this->atimFlash(__('your data has been saved'), $urlToFlash);
        }
    }
}