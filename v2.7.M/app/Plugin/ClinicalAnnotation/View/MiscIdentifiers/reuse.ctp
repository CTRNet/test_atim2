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
            'description' => __('select an identifier to assign to the current participant')
        )
    ),
    'links' => array(
        'radiolist' => array(
            'MiscIdentifier.selected_id' => '%%MiscIdentifier.id%%'
        ),
        'bottom' => array(
            'cancel' => '/ClinicalAnnotation/Participants/profile/' . $atimMenuVariables['Participant.id']
        ),
        'top' => '/ClinicalAnnotation/MiscIdentifiers/reuse/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['MiscIdentifierControl.id'] . '/1/'
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}
$this->Structures->build($atimStructure, $finalOptions);