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
    'top' => '/Users/resetForgottenPassword/',
    'bottom' => array(
        'cancel' => '/'
    )
);

$structureSettings = array(
    'header' => array(
        'title' => __('reset password'),
        'description' => __('step %s', $resetForgottenPasswordStep) . ' : ' . (($resetForgottenPasswordStep == '1') ? __('please enter you username') : __('please complete the security questions'))
    )
);

echo "<div class='validation hidden' id='timeErr'><ul class='warning'><li>" . __("server_client_time_discrepency") . "</li></ul></div>";

$this->Structures->build($atimStructure, array(
    'type' => 'edit',
    'links' => $structureLinks,
    'settings' => $structureSettings
));