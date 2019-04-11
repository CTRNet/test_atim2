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
    'index' => '/ClinicalAnnotation/ParticipantMessages/detail/%%ParticipantMessage.participant_id%%/%%ParticipantMessage.id%%/',
    'bottom' => array(
        'add participant' => '/ClinicalAnnotation/Participants/add/'
    )
);

$settings = array(
    'return' => true
);
if (isset($isAjax)) {
    $settings['actions'] = false;
} else {
    $settings['header'] = __('search type', null) . ': ' . __('participant messages', null);
}

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $settings
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$page = $this->Structures->build($finalAtimStructure, $finalOptions);

if (isset($isAjax)) {
    $this->layout = 'json';
    $this->json = array(
        'page' => $page,
        'new_search_id' => AppController::getNewSearchId()
    );
} else {
    echo $page;
}