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
    'top' => '/Tools/CollectionProtocol/add/',
    'bottom' => array(
        'cancel' => '/Tools/Template/listProtocolsAndTemplates/'
    )
);

// 1- PROTOCOL

$structureSettings = array(
    'actions' => false,
    'header' => __('protocol', null),
    'form_bottom' => false
);

$finalAtimStructure = $collectionProtocolStructure;
$finalOptions = array(
    'settings' => $structureSettings,
    'links' => $structureLinks,
    'data' => $collectionProtocolData
);

$hookLink = $this->Structures->hook('protocol');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// 2- SEPARATOR

$structureSettings = array(
    'actions' => false,
    'header' => __('visits', null),
    'form_top' => false,
    'form_bottom' => false
);

$this->Structures->build($emptyStructure, array(
    'settings' => $structureSettings
));

// 3- VISIT

$structureSettings = array(
    'pagination' => false,
    'add_fields' => true,
    'del_fields' => true,
    'form_top' => false
);

$finalAtimStructure = $collectionProtocolVisitStructure;
$finalOptions = array(
    'links' => $structureLinks,
    'data' => $collectionProtocolVisitData,
    'type' => 'addgrid',
    'settings' => $structureSettings
);

$hookLink = $this->Structures->hook('visit');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

?>

<div id="debug"></div>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>