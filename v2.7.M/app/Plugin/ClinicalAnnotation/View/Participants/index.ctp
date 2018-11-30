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
require ('search_links_n_options.php');
$finalOptions['settings']['return'] = true;
$finalOptions['settings']['pagination'] = false;
$finalOptions['settings']['header'] = false;
$finalOptions['settings']['actions'] = false;
$last5 = $this->Structures->build($finalAtimStructure, $finalOptions);

$structureLinks = array(
    'bottom' => array(
        'add participant' => '/ClinicalAnnotation/Participants/add'
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => '/ClinicalAnnotation/Participants/search/' . AppController::getNewSearchId() . '/'
    ),
    'settings' => array(
        'header' => __('search type', null) . ': ' . __('participants', null),
        'actions' => false
    )
);

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => $structureLinks,
    'extras' => '<div class="ajax_search_results"></div><div class="ajax_search_results_default">' . $last5 . '</div>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook('index'); // when the caller is search, the hook will be 'search_index.php'
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
$this->Structures->build($finalAtimStructure2, $finalOptions2);