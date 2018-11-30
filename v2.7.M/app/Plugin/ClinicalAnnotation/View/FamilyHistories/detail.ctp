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
        'edit' => '/ClinicalAnnotation/FamilyHistories/edit/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['FamilyHistory.id'],
        'delete' => '/ClinicalAnnotation/FamilyHistories/delete/' . $atimMenuVariables['Participant.id'] . '/' . $atimMenuVariables['FamilyHistory.id']
    )
);

// Set form structure and option
/* ==> Note: Set both form structure and option into 2 variables to allow hooks to modify them */
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);