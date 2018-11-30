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
    'bottom' => array(
        'new search' => OrderAppController::$searchLinks,
        'add' => '/Order/Orders/add/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'search',
    'links' => array(
        'top' => array(
            'search' => '/Order/Orders/search/' . AppController::getNewSearchId()
        )
    ),
    'settings' => array(
        'header' => __('search type', null) . ': ' . __('order', null),
        'actions' => false
    )
);

$finalAtimStructure2 = $emptyStructure;
$finalOptions2 = array(
    'links' => $structureLinks,
    'extras' => '<div class="ajax_search_results"></div>'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);
$this->Structures->build($finalAtimStructure2, $finalOptions2);