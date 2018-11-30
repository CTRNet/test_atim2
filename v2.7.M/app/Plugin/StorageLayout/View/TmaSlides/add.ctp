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
    'top' => '/StorageLayout/TmaSlides/add/' . $tmaBlockStorageMasterId,
    'bottom' => array(
        'cancel' => $urlToCancel
    )
);

$parentSettings = array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false,
        'form_top' => false,
        'form_bottom' => false,
        'header' => $tmaBlockStorageMasterId ? '' : __('tma slides creation'),
        'stretch' => false,
        'section_start' => ($tmaBlockStorageMasterId ? false : true)
    )
);

$childrenSettings = array(
    'type' => 'addgrid',
    'links' => $structureLinks,
    'settings' => array(
        'actions' => false,
        'form_top' => false,
        'form_bottom' => false,
        "add_fields" => true,
        "del_fields" => true,
        'header' => $tmaBlockStorageMasterId ? __('tma slides creation') : '',
        "language_heading" => $tmaBlockStorageMasterId ? '' : __('tma slides'),
        'section_end' => ($tmaBlockStorageMasterId ? false : true)
    )
);

$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// Display empty structure with hidden fields to fix issue#2243
$emptyStructureOptions = $parentSettings;
$emptyStructureOptions['settings']['form_top'] = true;
$emptyStructureOptions['settings']['language_heading'] = '';
$emptyStructureOptions['settings']['header'] = '';
$emptyStructureOptions['data'] = array();
$emptyStructureOptions['extras'] = '<input type="hidden" name="data[url_to_cancel]" value="' . $urlToCancel . '"/>';

$this->Structures->build(array(), $emptyStructureOptions);

// BUILD FORM

$hookLink = $this->Structures->hook('loop');

$first = true;
$creation = 0;

$manyTmaBlocks = (sizeof($this->request->data) == 1) ? false : true;
while ($dataUnit = array_shift($this->request->data)) {
    $finalOptionsParent = $parentSettings;
    $finalOptionsChildren = $childrenSettings;
    
    $finalOptionsParent['settings']['header'] .= $manyTmaBlocks ? " #" . (++ $creation) : '';
    
    $finalOptionsParent['settings']['name_prefix'] = $dataUnit['parent']['StorageMaster']['id'];
    $finalOptionsChildren['settings']['name_prefix'] = $dataUnit['parent']['StorageMaster']['id'];
    
    $finalOptionsParent['data'] = $dataUnit['parent'];
    $finalOptionsChildren['data'] = $dataUnit['children'];
    
    if ($first) {
        $first = false;
        $finalOptionsParent['settings']['form_top'] = true;
    }
    if (empty($this->request->data)) {
        $finalOptionsChildren['settings']['actions'] = true;
        $finalOptionsChildren['settings']['form_bottom'] = true;
        if ($manyTmaBlocks)
            $finalOptionsChildren['settings']['confirmation_msg'] = __('multi_entry_form_confirmation_msg');
    }
    
    $finalStructureParent = $tmaBlocksAtimStructure;
    $finalStructureChildren = $atimStructure;
    
    if ($hookLink) {
        require ($hookLink);
    }
    
    if (! $tmaBlockStorageMasterId)
        $this->Structures->build($finalStructureParent, $finalOptionsParent);
    $this->Structures->build($finalStructureChildren, $finalOptionsChildren);
}
?>
<script>
var copyControl = true;
</script>