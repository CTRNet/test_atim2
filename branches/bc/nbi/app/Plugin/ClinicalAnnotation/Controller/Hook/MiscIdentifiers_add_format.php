<?php
/**
 * **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2019-02-21
 */

if($controls['MiscIdentifierControl']['flag_confidential']) {
    // TODO: Implement rules to manage confidential identifiers managment for participants of the 'Retrospective Bank'.
    $this->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
}