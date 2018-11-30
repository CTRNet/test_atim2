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
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'settings' => array(
        'pagination' => false,
        'form_inputs' => false,
        'header' => array(
            'title' => $title,
            'description' => __('select the identifiers you wish to delete permanently')
        ),
        'confirmation_msg' => __('core_are you sure you want to delete this data?')
    ),
    'links' => array(
        'bottom' => array(),
        'top' => '/Administrate/ReusableMiscIdentifiers/manage/' . $atimMenuVariables['MiscIdentifierControl.id'],
        'checklist' => array(
            'MiscIdentifier.selected_id][' => '%%MiscIdentifier.id%%'
        )
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($finalAtimStructure, $finalOptions);