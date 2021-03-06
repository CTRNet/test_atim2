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
$atimFinalStructure = $atimStructure;
if (empty($this->request->data) && ! $searchId) {
    $finalOptions = array(
        'type' => 'search',
        'links' => array(
            'top' => '/Administrate/AdminUsers/search/' . AppController::getNewSearchId()
        ),
        'settings' => array(
            'header' => __('search type') . ": " . __('users'),
            'actions' => false,
            'return' => true
        )
    );
    
    $finalAtimStructure2 = $emptyStructure;
    $finalOptions2 = array(
        'links' => array(
            'bottom' => array()
        ),
        'extras' => '<div class="ajax_search_results"></div>'
    );
    
    $hookLink = $this->Structures->hook('form');
    if ($hookLink) {
        require ($hookLink);
    }
} else {
    $finalOptions = array(
        'type' => 'index',
        'links' => array(
            'bottom' => array(),
            'index' => array(
                'detail' => '/Administrate/AdminUsers/detail/%%User.group_id%%/%%User.id%%/'
            )
        ),
        'settings' => array(
            'return' => true
        )
    );
    
    if (isset($isAjax)) {
        $finalOptions['settings']['actions'] = false;
    }
    
    $hookLink = $this->Structures->hook('results');
    if ($hookLink) {
        require ($hookLink);
    }
}

$form = $this->Structures->build($atimFinalStructure, $finalOptions);
if (isset($isAjax)) {
    $this->layout = 'json';
    $this->json = array(
        'page' => $form,
        'new_search_id' => AppController::getNewSearchId()
    );
} else {
    echo $form;
}

if (isset($finalAtimStructure2)) {
    $this->Structures->build($finalAtimStructure2, $finalOptions2);
}