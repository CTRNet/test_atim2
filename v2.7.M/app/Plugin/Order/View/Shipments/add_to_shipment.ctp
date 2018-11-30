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
    'top' => '/Order/Shipments/addToShipment/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . "/$orderLineId",
    'bottom' => array(
        'cancel' => '/Order/Shipments/detail/' . $atimMenuVariables['Order.id'] . '/' . $atimMenuVariables['Shipment.id'] . '/'
    ),
    'checklist' => array(
        'OrderItem.id][' => '%%OrderItem.id%%'
    )
);

$structureSettings = array(
    'pagination' => true,
    'header' => __('add items to shipment', null),
    'form_inputs' => false
);

$finalOptions = array(
    'type' => 'index',
    'links' => $structureLinks,
    'settings' => $structureSettings
);

if (isset($languageHeading)) {
    $finalOptions['settings']['language_heading'] = $languageHeading;
}

$finalAtimStructure = $atimStructure;

// CUSTOM CODE
$hookLink = $this->Structures->hook();

// BUILD FORM

$this->Structures->build($finalAtimStructure, $finalOptions);

?>
<script>
    var dataLimit=<?php echo $dataLimit;?>;
    var dataIndex="<?php echo "OrderItem";?>";
    var controller="<?php echo "Shipments";?>"; //Until now not used in Javascript's code
    var action="<?php echo "addToShipment";?>"; //Until now not used in Javascript's code
</script>