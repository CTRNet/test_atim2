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
 
$linkedRecordsProperties = array(
    'participants' => array(
        'ClinicalAnnotation.Participant.cusm_cim_study_summary_id',
        '/ClinicalAnnotation/Participants/profile/',
        'participants',
        '/ClinicalAnnotation/Participants/profile/%%Participant.id%%'
    ),
    'aliquots' => array(
        'InventoryManagement.AliquotMaster.study_summary_id',
        '/InventoryManagement/AliquotMasters/detail/',
        'view_aliquot_joined_to_sample_and_collection',
        '/InventoryManagement/AliquotMasters/detail/%%ViewAliquot.collection_id%%/%%ViewAliquot.sample_master_id%%/%%ViewAliquot.aliquot_master_id%%'
    )
);