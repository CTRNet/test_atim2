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
// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => '/ClinicalAnnotation/ParticipantMessages/search/' . AppController::getNewSearchId()
    ),
    'settings' => array(
        'header' => __('search type', null) . ': ' . __('participant messages', null),
        'actions' => false
    )
);

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'extras' => '<div class="ajax_search_results"></div>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('index'); // when the caller is search, the hook will be 'search_index.php'
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
$this->Structures->build($finalAtimStructure2, $finalOptions2);