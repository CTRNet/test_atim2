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

// Tumor registery data can only be created/modified by the Tumor Registry data migration (using 'System' user)
// No tumor registry event can be created by user

if (! in_array(AppController::getInstance()->Session->read('Auth.User.username'), array('NicoEn','system'))) {
    if (isset($addLinks)) {
        foreach ($addLinks as $controlType => $link) {
            if (preg_match('/^((tumor Registry)|(Registre des tumeurs))/i', $controlType)) {
                unset($finalOptions['links']['bottom']['add'][$controlType]);
            }
        }
    }
    if (! isset($this->data[0]['EventControl']['event_type']) || preg_match('/^tumor registry/i', $this->data[0]['EventControl']['event_type'])) {
        unset($finalOptions['links']['index']['edit']);
        unset($finalOptions['links']['index']['delete']);
    }
}