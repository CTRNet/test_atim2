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
$this->Structures->build($atimStructure, array(
    'type' => 'batchedit',
    'links' => array(
        'top' => '/ClinicalAnnotation/Participants/batchEdit'
    ),
    'settings' => array(
        'header' => array(
            'title' => __('participants') . " - " . __('batch edit'),
            'description' => __('you are about to edit %d element(s)', count(explode(",", $this->request->data[0]['ids'])))
        ),
        'confirmation_msg' => __('batch_edit_confirmation_msg')
    )
));