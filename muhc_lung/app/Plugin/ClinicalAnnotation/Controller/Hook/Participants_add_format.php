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
// Tumor Registery Data Migration
// --------------------------------------------------------------------------------

if (in_array(AppController::getInstance()->Session->read('Auth.User.username'), array('system'))) {
    // Add structure to allow Tumor Registry Data migration using 'System' user
    $this->Structures->set('participants,cums_lung_participants_tumor_registry');
}