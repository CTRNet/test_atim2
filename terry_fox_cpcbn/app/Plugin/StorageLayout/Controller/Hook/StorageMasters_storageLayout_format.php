<?php
if ($csvCreation > 1) {
    // Export for review: reformat DisplayData.label
    foreach ($data['children'] as &$tmpChildren) {
        $AliquotControlModel = AppModel::getInstance("InventoryManagement", "AliquotControl", true);
        $tissueCoreControl = $AliquotControlModel->find('first', array(
            'conditions' => array(
                'AliquotControl.databrowser_label' => 'tissue|core'
            )
        ));
        if ($tmpChildren['DisplayData']['type'] == 'AliquotMaster' && $tmpChildren['AliquotMaster']['aliquot_control_id'] == $tissueCoreControl['AliquotControl']['id'] && $tmpChildren['sample_master_dup']['qc_tf_is_tma_sample_control'] == 'n') {
            if (preg_match('/^([TNUB])(\ \-\ P#\ ([0-9]+)){0,1}/', $tmpChildren['DisplayData']['label'], $matches)) {
                $atimParticipantNbr = isset($matches[3]) ? $matches[3] : '?';
                $aliquotLabelBeingNature = $matches[1];
                $aliquotTfriNbr = $tmpChildren['AliquotMaster']['barcode'];
                switch ($csvCreation) {
                    case '2':
                        // for review (participant_identifier+aliquot_label) :: ATiM Participant # + Aliquot TFRI Label (Nature)
                        $tmpChildren['DisplayData']['label'] = $atimParticipantNbr . "_" . $aliquotLabelBeingNature;
                        break;
                    case '3':
                        // for review (participant_identifier+aliquot_label+aliquot_barcode) :: ATiM Participant # + Aliquot TFRI Label (Nature) + Aliquot TFRI#
                        $tmpChildren['DisplayData']['label'] = $atimParticipantNbr . "_" . $aliquotLabelBeingNature . "_" . $aliquotTfriNbr;
                        break;
                    case '4':
                        // for review (aliquot_label+aliquot_barcode) :: Aliquot TFRI Label (Nature) + Aliquot TFRI#
                        $tmpChildren['DisplayData']['label'] = $aliquotLabelBeingNature . "_" . $aliquotTfriNbr;
                        break;
                    default:
                }
            }
        }
    }
}