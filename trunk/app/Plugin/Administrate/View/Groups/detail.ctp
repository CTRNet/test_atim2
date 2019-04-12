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
        'edit' => '/Administrate/Groups/edit/%%Group.id%%',
        'delete' => '/Administrate/Groups/delete/%%Group.id%%',
        'add user' => '/Administrate/AdminUsers/add/%%Group.id%%'
    )
);
if (! $displayEditButton) {
    unset($structureLinks['bottom']['delete'], $structureLinks['bottom']['edit']);
}

$this->Structures->build($atimStructure, array(
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false
    )
));

$finalAtimStructure = array();
$finalOptions = array(
    'type' => 'detail',
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('users', null)
    ),
    'extras' => $this->Structures->ajaxIndex('Administrate/AdminUsers/listall/' . $atimMenuVariables['Group.id'])
);

$this->Structures->build($finalAtimStructure, $finalOptions);