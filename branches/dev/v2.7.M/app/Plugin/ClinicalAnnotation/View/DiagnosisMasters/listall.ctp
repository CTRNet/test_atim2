<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */
$structureLinks = array(
    'tree' => array(
        'DiagnosisMaster' => array(
            'see diagnosis summary' => array(
                'link' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
                'icon' => 'diagnosis'
            ),
            'access to all data' => array(
                'link' => '/ClinicalAnnotation/DiagnosisMasters/detail/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/',
                'icon' => 'detail'
            ),
            'add' => AppController::checkLinkPermission('/ClinicalAnnotation/DiagnosisMasters/add/') ? 'javascript:addPopup(%%DiagnosisMaster.id%%, %%DiagnosisControl.id%%);' : 'javascript:addPopup(0)'
        ),
        'TreatmentMaster' => array(
            'see treatment summary' => array(
                'link' => '/ClinicalAnnotation/TreatmentMasters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/1',
                'icon' => 'treatments'
            ),
            'access to all data' => array(
                'link' => '/ClinicalAnnotation/TreatmentMasters/detail/%%TreatmentMaster.participant_id%%/%%TreatmentMaster.id%%/',
                'icon' => 'detail'
            )
        ),
        'EventMaster' => array(
            'see event summary' => array(
                'link' => '/ClinicalAnnotation/EventMasters/detail/%%EventMaster.participant_id%%/%%EventMaster.id%%/1',
                'icon' => 'annotation'
            ),
            'access to all data' => array(
                'link' => '/ClinicalAnnotation/EventMasters/detail/%%EventMaster.participant_id%%/%%EventMaster.id%%/',
                'icon' => 'detail'
            )
        )
    ),
    'ajax' => array(
        'index' => array(
            'see diagnosis summary' => array(
                'json' => array(
                    'update' => 'frame',
                    'callback' => 'set_at_state_in_tree_root'
                )
            ),
            'see treatment summary' => array(
                'json' => array(
                    'update' => 'frame',
                    'callback' => 'set_at_state_in_tree_root'
                )
            ),
            'see event summary' => array(
                'json' => array(
                    'update' => 'frame',
                    'callback' => 'set_at_state_in_tree_root'
                )
            )
        )
    ),
    'tree_expand' => array(
        'DiagnosisMaster' => '/ClinicalAnnotation/DiagnosisMasters/listall/%%DiagnosisMaster.participant_id%%/%%DiagnosisMaster.id%%/1'
    )
);

if (! $isAjax) {
    $addLinks = array();
    foreach ($diagnosisControlsList as $diagnosisControl) {
        if ($diagnosisControl['DiagnosisControl']['category'] == 'primary') {
            $addLinks[__($diagnosisControl['DiagnosisControl']['controls_type'])] = '/ClinicalAnnotation/DiagnosisMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $diagnosisControl['DiagnosisControl']['id'] . '/0/';
        }
    }
    ksort($addLinks);
    $structureLinks['bottom'] = array(
        'add primary' => $addLinks
    );
}

$structureExtras = array();
$structureExtras[10] = '<div id="frame"></div>';

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'tree',
    'links' => $structureLinks,
    'extras' => $structureExtras,
    'settings' => array(
        'tree' => array(
            'DiagnosisMaster' => 'DiagnosisMaster',
            'TreatmentMaster' => 'TreatmentMaster',
            'EventMaster' => 'EventMaster'
        ),
        'header' => array(
            'title' => '',
            'description' => __('information about the diagnosis module is available %s here', $helpUrl)
        )
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if (! $isAjax) {
    require ('add_popup.php');
}