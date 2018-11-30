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
$displayStudyInvestigators = true;
$displayStudyFundings = true;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
// StudySummary
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------

$structureLinks = array(
    'bottom' => array(
        'edit' => '/Study/StudySummaries/edit/%%StudySummary.id%%/',
        'delete' => '/Study/StudySummaries/delete/%%StudySummary.id%%/'
    )
);
if ($displayStudyInvestigators)
    $structureLinks['bottom']['add']['study investigator'] = '/Study/StudyInvestigators/add/' . $atimMenuVariables['StudySummary.id'];
if ($displayStudyFundings)
    $structureLinks['bottom']['add']['study funding'] = '/Study/StudyFundings/add/' . $atimMenuVariables['StudySummary.id'];
    
    // Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => array(
        'actions' => (! $displayStudyInvestigators && ! $displayStudyFundings)
    ),
    'links' => $structureLinks
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
// StudyInvestigator
// ---------------------------------------------------------------------------------------------------------------------------------------------------------------

$finalAtimStructure = $emptyStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('study investigator'),
        'actions' => (! $displayStudyFundings)
    ),
    'extras' => $this->Structures->ajaxIndex('Study/StudyInvestigators/listall/' . $atimMenuVariables['StudySummary.id'])
);

$hookLink = $this->Structures->hook('study_investigator');
if ($hookLink) {
    require ($hookLink);
}

if ($displayStudyInvestigators)
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------------
    // StudyInvestigator
    // ---------------------------------------------------------------------------------------------------------------------------------------------------------------

$finalAtimStructure = $emptyStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'header' => __('study funding')
    ),
    'extras' => $this->Structures->ajaxIndex('Study/StudyFundings/listall/' . $atimMenuVariables['StudySummary.id'])
);

$hookLink = $this->Structures->hook('study_funding');
if ($hookLink) {
    require ($hookLink);
}

if ($displayStudyFundings)
    $this->Structures->build($finalAtimStructure, $finalOptions);