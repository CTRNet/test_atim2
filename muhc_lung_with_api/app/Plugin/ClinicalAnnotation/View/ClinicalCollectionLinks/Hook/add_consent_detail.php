<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
$cstStructureSettings = $structureSettings;
$cstFinalOptions = $finalOptions;
$cstFinalAtimStructure = $finalAtimStructure;

// --------------------------------------------------------------------------------
// Collection to participant bank foreign key
// --------------------------------------------------------------------------------

// Identifier----------------

$structureLinks['radiolist'] = array(
    'Collection.misc_identifier_id' => '%%MiscIdentifier.id%%'
);
$structureSettings['header'] = __('misc identifiers');
$structureSettings['form_top'] = false;
$finalAtimStructure = $atimStructureMiscIdentifier;
$finalOptions = array(
    'type' => 'index',
    'data' => $miscIdentifierData,
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'extras' => array(
        'end' => '<input type="radio" name="data[Collection][misc_identifier_id]" ' . ($foundMId ? '' : 'checked="checked"') . '" value=""/>' . __('n/a')
    )
);
if (! AppController::checkLinkPermission('/ClinicalAnnotation/MiscIdentifiers/listall')) {
    $finalAtimStructure = array();
    $finalOptions['type'] = 'detail';
    $finalOptions['data'] = array();
    $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// --------------------------------------------------------------------------------
// Limit collection link to consent and identifier
// --------------------------------------------------------------------------------

// Consent----------------

$structureSettings = $cstStructureSettings;
$finalOptions = $cstFinalOptions;
$finalAtimStructure = $cstFinalAtimStructure;
$finalOptions['settings']['actions'] = true;
$finalOptions['settings']['form_bottom'] = true;