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

// Set identifier list

$joins[] = array(
    'table' => 'misc_identifiers',
    'alias' => 'MiscIdentifier',
    'type' => 'LEFT',
    'conditions' => array(
        'Collection.misc_identifier_id = MiscIdentifier.id'
    )
);