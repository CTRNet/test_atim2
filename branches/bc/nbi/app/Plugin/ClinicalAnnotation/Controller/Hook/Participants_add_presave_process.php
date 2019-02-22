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

// Manage profil change of the proifle data of the particiants of the retropsecitve bank
if($_SESSION['Auth']['User']['group_id'] != '1') {
    if($this->request->data['Participant']['bc_nbi_retrospective_bank'] != 'n') {
        $submittedDataValidates = false;
        $this->Participant->validationErrors['bc_nbi_retrospective_bank'][] = __('you are not allowed to define a particpant as a participant of the retrospecitve bank');
    }
}