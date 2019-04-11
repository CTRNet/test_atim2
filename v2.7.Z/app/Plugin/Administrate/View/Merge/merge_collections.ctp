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
if (isset($validationError)) {
    $this->validationErrors = array(
        'model' => array(
            $validationError
        )
    );
}

$links = array(
    'top' => '/Administrate/Merge/mergeCollections/',
    'bottom' => array(
        'cancel' => '/Administrate/Merge/index/'
    )
);
$this->Structures->build(array(), array(
    'type' => 'detail',
    'settings' => array(
        'header' => array(
            'title' => __('merge collection'),
            'description' => __('merge_coll_desc')
        ),
        'actions' => false,
        'form_bottom' => false
    ),
    'extras' => array(
        'end' => $this->Structures->generateSelectItem('InventoryManagement/Collections/search?nolatest=', 'from')
    ),
    'links' => $links
));
$this->Structures->build(array(), array(
    'type' => 'detail',
    'settings' => array(
        'header' => array(
            'title' => __('into collection'),
            'description' => __('merge_coll_into_desc'),
            'form_bottom' => true
        ),
        'confirmation_msg' => __('merge_confirmation_msg')
    ),
    'extras' => array(
        'end' => $this->Structures->generateSelectItem('InventoryManagement/Collections/search?nolatest=', 'to')
    ),
    'links' => $links
));