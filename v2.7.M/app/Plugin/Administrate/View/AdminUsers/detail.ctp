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
if ($_SESSION['Auth']['User']['id'] == $atimMenuVariables['User.id']) {
    $structureLinks = array(
        'bottom' => array(
            'edit' => '/Administrate/AdminUsers/edit/' . $atimMenuVariables['Group.id'] . '/%%User.id%%'
        )
    );
} else {
    $structureLinks = array(
        'bottom' => array(
            'edit' => '/Administrate/AdminUsers/edit/' . $atimMenuVariables['Group.id'] . '/%%User.id%%',
            'change group' => array(
                'link' => '/Administrate/AdminUsers/changeGroup/' . $atimMenuVariables['Group.id'] . '/%%User.id%%',
                'icon' => 'users'
            ),
            'delete' => '/Administrate/AdminUsers/delete/' . $atimMenuVariables['Group.id'] . '/%%User.id%%'
        )
    );
}
$this->Structures->build($atimStructure, array(
    'links' => $structureLinks
));