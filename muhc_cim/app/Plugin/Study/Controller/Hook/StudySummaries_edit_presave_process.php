<?php

/** **********************************************************************
 * CUSM-CIM Project.
 * ***********************************************************************
 * 
 * Study plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-02-21
 */

// Bank can not be changed to avoid any update on following objects (note: Field Bank is supposed to be read-only in edit mode):
// - Participant
// - Collection
// - Aliquot
if ($studySummaryData['StudySummary']['cusm_cim_bank_id'] != $this->request->data['StudySummary']['cusm_cim_bank_id']) {exit;
    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
}
