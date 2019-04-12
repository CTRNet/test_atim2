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
AppController::addInfoMsg(__('all changes will be applied to the all'));
AppController::addInfoMsg(__("keep the 'new value' field empty to not change data and use the 'erase/remove' checkbox to erase the data"));

$aliquotIds = array();
if (isset($this->request->data['ViewAliquot']['aliquot_master_id'])) {
    $aliquotIds = implode(',', array_filter($this->request->data['ViewAliquot']['aliquot_master_id']));
} else {
    $aliquotIds = $this->request->data['aliquot_ids'];
}
$this->Structures->build($atimStructure, array(
    'type' => 'edit',
    'links' => array(
        'top' => '/InventoryManagement/AliquotMasters/editInBatch/',
        'bottom' => array(
            'cancel' => $cancelLink
        )
    ),
    'settings' => array(
        'header' => array(
            'title' => __('aliquots') . ' - ' . __('batch edit'),
            'description' => __('you are about to edit %d element(s)', substr_count($aliquotIds, ',') + 1)
        ),
        'confirmation_msg' => __('batch_edit_confirmation_msg')
    ),
    'extras' => $this->Form->text('aliquot_ids', array(
        "type" => "hidden",
        "id" => false,
        "value" => $aliquotIds
    )) . $this->Form->text('cancel_link', array(
        "type" => "hidden",
        "id" => false,
        "value" => $cancelLink
    ))
));