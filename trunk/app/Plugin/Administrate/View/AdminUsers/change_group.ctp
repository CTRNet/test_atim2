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
$finalOptions = array(
    'type' => 'edit',
    'links' => array(
        'top' => sprintf('/Administrate/AdminUsers/changeGroup/%d/%d/', $atimMenuVariables['Group.id'], $atimMenuVariables['User.id']),
        'bottom' => array(
            'cancel' => sprintf('/Administrate/AdminUsers/detail/%d/%d/', $atimMenuVariables['Group.id'], $atimMenuVariables['User.id'])
        )
    )
);

$finalAtimStructure = $atimStructure;

$this->Structures->build($finalAtimStructure, $finalOptions);