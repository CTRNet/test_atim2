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
    'top' => '/ClinicalAnnotation/MiscIdentifiers/add/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['MiscIdentifierControl.id'] . '/',
    'bottom' => array(
        'cancel' => '/ClinicalAnnotation/Participants/profile/' . $atimMenuVariables['Participant.id'] . '/'
    )
);

$structureOverride = array();

if (isset($this->request->data['MiscIdentifierControl']['misc_identifier_format']) && $this->request->data['MiscIdentifierControl']['misc_identifier_format']) {
    $structureOverride['MiscIdentifier.identifier_value'] = $this->request->data['MiscIdentifierControl']['misc_identifier_format'];
}

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'override' => $structureOverride
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);