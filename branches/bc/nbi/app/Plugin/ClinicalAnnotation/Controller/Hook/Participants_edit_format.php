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
if($participantData['Participant']['bc_nbi_retrospective_bank'] != 'n' && $_SESSION['Auth']['User']['group_id'] != '1') {
    $this->atimFlashWarning(__('you are not allowed to edit participant of the retrospective bank'), '/ClinicalAnnotation/Participants/profile/' . $participantId . '/'); 
}