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
    $fields[] = 'misc_identifier_id';
    $this->Collection->addWritableField($fields);
}