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
AppController::addInfoMsg(__('add_order_items_info'));
$structureLinks = array(
    'top' => '/Order/OrderItems/add/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/' . $objectModelName,
    'bottom' => array(
        'cancel' => empty($atimMenuVariables['OrderLine.id']) ? '/Order/Orders/detail/' . $atimMenuVariables['Order.id'] . '/' : '/Order/OrderLines/detail/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['OrderLine.id'] . '/'
    )
);

$structureOverride = array();

$finalAtimStructure = $atimStructure;
$finalOptions = array(
    'settings' => array(
        'header' => __((empty($atimMenuVariables['OrderLine.id']) ? 'add items to order' : 'add items to line'), null) . ' : ' . __(($objectModelName == 'AliquotMaster' ? 'aliquot' : 'tma slide')),
        'paste_disabled_fields' => array(
            $objectModelName . '.barcode'
        ),
        'pagination' => false,
        'add_fields' => true,
        'del_fields' => true
    ),
    'links' => $structureLinks,
    'override' => $structureOverride,
    'type' => 'addgrid'
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

// BUILD FORM
$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<script type="text/javascript">
var copyStr = "<?php echo(__("copy", null)); ?>";
var pasteStr = "<?php echo(__("paste")); ?>";
var copyingStr = "<?php echo(__("copying")); ?>";
var pasteOnAllLinesStr = "<?php echo(__("paste on all lines")); ?>";
var copyControl = true;
</script>