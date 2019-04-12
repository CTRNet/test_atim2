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
    'top' => '/Administrate/StorageControls/edit/' . $atimMenuVariables['StorageCtrl.id'] . '/',
    'bottom' => array(
        'cancel' => '/Administrate/StorageControls/listAll/'
    )
);

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => array(
        'header' => __('storage layout description', null) . ' : ' . __(str_replace(array(
            'no_d',
            '1d',
            '2d',
            'tma'
        ), array(
            'no coordinate',
            '1 coordinate',
            '2 coordinates',
            'tma block'
        ), $storageCategory))
    ),
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);