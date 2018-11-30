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
    'top' => '/Administrate/Announcements/edit/' . $atimMenuVariables['Announcement.id'],
    'bottom' => array(
        'cancel' => '/Administrate/Announcements/detail/' . $atimMenuVariables['Announcement.id']
    )
);

$finalOptions = array(
    'links' => $structureLinks,
    'settings' => array(
        'header' => isset($atimMenuVariables['User.id']) ? '' : __('announcement', null)
    )
);

// CUSTOM CODE
$hookLink = $this->Structures->hook();
if ($hookLink) {
    require ($hookLink);
}

$this->Structures->build($atimStructure, $finalOptions);