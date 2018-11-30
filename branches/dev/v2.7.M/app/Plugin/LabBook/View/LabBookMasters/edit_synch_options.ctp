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
    "top" => '/labbook/LabBookMasters/editSynchOptions/' . $atimMenuVariables['LabBookMaster.id'],
    'bottom' => array(
        'cancel' => '/labbook/LabBookMasters/detail/' . $atimMenuVariables['LabBookMaster.id']
    )
);

// DERIVATIVE DETAILS

$structureOverride = array();
$settings = array(
    'header' => __('derivative', null),
    'actions' => false,
    "form_bottom" => false,
    'pagination' => false,
    'name_prefix' => 'derivative'
);

$finalAtimStructure = $labBookDerivativesSummary;
$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'override' => $structureOverride,
    'data' => $this->request->data['derivative'],
    'settings' => $settings
);

$hookLink = $this->Structures->hook('derivatives');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);

// REALIQUOTING

$structureOverride = array();
$settings = array(
    'header' => __('realiquoting', null),
    'pagination' => false,
    'name_prefix' => 'realiquoting'
);

$finalAtimStructure = $labBookRealiquotingsSummary;
$finalOptions = array(
    'type' => 'editgrid',
    'links' => $structureLinks,
    'override' => $structureOverride,
    'data' => $this->request->data['realiquoting'],
    'settings' => $settings
);

$hookLink = $this->Structures->hook('derivatives');
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($finalAtimStructure, $finalOptions);