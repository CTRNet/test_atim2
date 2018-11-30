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
$addLinks = array();
foreach ($consentControlsList as $consentControl) {
    $addLinks[__($consentControl['ConsentControl']['controls_type'])] = '/ClinicalAnnotation/ConsentMasters/add/' . $atimMenuVariables['Participant.id'] . '/' . $consentControl['ConsentControl']['id'] . '/';
}
natcasesort($addLinks);

$structureLinks = array(
    'top' => null,
    'index' => array(
        'detail' => '/ClinicalAnnotation/ConsentMasters/detail/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%',
        'edit' => '/ClinicalAnnotation/ConsentMasters/edit/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%',
        'delete' => '/ClinicalAnnotation/ConsentMasters/delete/' . $atimMenuVariables['Participant.id'] . '/%%ConsentMaster.id%%'
    ),
    'bottom' => array(
        'add' => $addLinks
    )
);

// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);