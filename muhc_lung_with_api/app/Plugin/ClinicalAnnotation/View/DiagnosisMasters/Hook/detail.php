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
 *       
 */
 
// --------------------------------------------------------------------------------
// Tumor Registery Data Migration
// --------------------------------------------------------------------------------

// Tumor registery diagnosis can only be created/modified by the Tumor Registry data migration (using 'System' user)
// No diagnosis can be created by user

if (! in_array(AppController::getInstance()->Session->read('Auth.User.username'), array('system'))) {
    unset($structureLinks['bottom']);
    unset($finalOptions['links']['bottom']);
}

// --------------------------------------------------------------------------------
// No collection to diagnosis link
// --------------------------------------------------------------------------------

$finalOptions['settings']['actions'] = true;
$isAjax = true;