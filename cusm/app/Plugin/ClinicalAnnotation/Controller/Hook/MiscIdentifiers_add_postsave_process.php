<?php

/**
 * Hook :: Modify generated bank identifiers 
 *   - Lung : Add year to the Lung Bank Identifier
 *
 * @author Nicolas Luc
 *
 * @package ATiM CUSM
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
