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
$identifiersMenu = array();
$linkAvailability = AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/reuse/');
$sort0 = array();
$sort1 = array();
foreach ($identifierControlsList as &$option) {
    $option['MiscIdentifierControl']['misc_identifier_name'] = __($option['MiscIdentifierControl']['misc_identifier_name']);
    $sort0[] = $option['MiscIdentifierControl']['display_order'];
    $sort1[] = $option['MiscIdentifierControl']['misc_identifier_name'];
}
array_multisort($sort0, SORT_ASC, $sort1, SORT_ASC, $identifierControlsList);

foreach ($identifierControlsList as $newOption) {
    $identifiersMenu[$newOption['MiscIdentifierControl']['misc_identifier_name']] = isset($newOption['reusable']) && $linkAvailability ? 'javascript:miscIdPopup(' . $atimMenuVariables['Participant.id'] . ' ,' . $newOption['MiscIdentifierControl']['id'] . ');' : '/ClinicalAnnotation/MiscIdentifiers/add/' . $atimMenuVariables['Participant.id'] . '/' . $newOption['MiscIdentifierControl']['id'] . '/';
}

if (empty($identifiersMenu)) {
    $identifiersMenu = '/underdev/';
}

$addCollectionButtonLinks = array(
    'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/',
    'icon' => 'add_collection'
);
if ($collectionProtocols) {
    $addCollectionButtonLinks = array();
    $addCollectionButtonLinks['collection'] = array(
        'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/',
        'icon' => 'add_collection'
    );
    foreach ($collectionProtocols as $collectionProtocolId => $collectionProtocolName) {
        $addCollectionButtonLinks[$collectionProtocolName] = array(
            'link' => '/ClinicalAnnotation/ClinicalCollectionLinks/add/' . $atimMenuVariables['Participant.id'] . '/' . $collectionProtocolId,
            'icon' => 'add_collection_protocol'
        );
    }
}

// 1- PARTICIPANT PROFILE
$structureLinks = array(
    'index' => array(),
    'bottom' => array(
        'edit' => '/ClinicalAnnotation/Participants/edit/' . $atimMenuVariables['Participant.id'],
        'delete' => '/ClinicalAnnotation/Participants/delete/' . $atimMenuVariables['Participant.id'],
        'add identifier' => $identifiersMenu,
        'add collection' => $addCollectionButtonLinks
    )
);
// Set form structure and option
$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'type' => 'detail',
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

if (! $isAjax) {
    
    // 2- PARTICIPANT IDENTIFIER
    $structureLinks['index'] = array(
        'edit' => '/ClinicalAnnotation/MiscIdentifiers/edit/' . $atimMenuVariables['Participant.id'] . '/%%MiscIdentifier.id%%/',
        'delete' => '/ClinicalAnnotation/MiscIdentifiers/delete/' . $atimMenuVariables['Participant.id'] . '/%%MiscIdentifier.id%%/'
    );
    
    $finalOptions = array(
        'links' => $structureLinks,
        'settings' => array(
            'header' => __('misc identifiers', null)
        )
    );
    if (AppController::checkLinkPermission('ClinicalAnnotation/MiscIdentifiers/listall/')) {
        $finalOptions['type'] = 'index';
        $finalOptions['data'] = $participantIdentifiersData;
        $finalAtimStructure = $atimStructureForMiscIdentifiers;
    } else {
        $finalAtimStructure = $emptyStructure;
        $finalOptions['type'] = 'detail';
        $finalOptions['data'] = array();
        $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
    }
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('identifiers');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);
}
?>
<script>
var STR_MISC_IDENTIFIER_REUSE = "<?php echo __('misc_identifier_reuse'); ?>";
var STR_NEW = "<?php echo __('new'); ?>";
var STR_REUSE = "<?php echo __('reuse'); ?>";
</script>