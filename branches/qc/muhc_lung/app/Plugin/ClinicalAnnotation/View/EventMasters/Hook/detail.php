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
// No collection to event and diagnosis to event links
// --------------------------------------------------------------------------------

$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;
$isAjax = true;

// --------------------------------------------------------------------------------
// Tumor Registery Data Migration
// --------------------------------------------------------------------------------

// Tumor registery data can only be created/modified by the Tumor Registry data migration (using 'System' user)
// No tumor registry event can be created by user

if (preg_match('/^tumor registry/', $this->data['EventControl']['event_type']) 
&& ! in_array(AppController::getInstance()->Session->read('Auth.User.username'), array( 'system'))) {
    unset($finalOptions['links']['bottom']);
}