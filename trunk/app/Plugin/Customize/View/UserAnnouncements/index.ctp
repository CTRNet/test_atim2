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
if (in_array($listType, array(
    'all',
    'current'
))) {
    
    $structureLinks = array(
        'index' => array(
            'detail' => '/Customize/UserAnnouncements/detail/%%Announcement.id%%'
        )
    );
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook();
    if ($hookLink) {
        require ($hookLink);
    }
    
    $this->Structures->build($atimStructure, array(
        'links' => $structureLinks
    ));
} else {
    
    // --------- Lists with current announcements ----------------------------------------------------------------------------------------------
    
    $finalAtimStructure = array();
    $finalOptions = array(
        'type' => 'detail',
        'links' => array(),
        'settings' => array(
            'header' => __('news', null),
            'actions' => false
        ),
        'extras' => $this->Structures->ajaxIndex('Customize/UserAnnouncements/index/current')
    );
    
    $displayNextForm = true;
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('current');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    if ($displayNextForm)
        $this->Structures->build($finalAtimStructure, $finalOptions);
        
        // --------- Empty lists ----------------------------------------------------------------------------------------------
    
    $finalAtimStructure = array();
    $finalOptions = array(
        'type' => 'detail',
        'links' => array(),
        'settings' => array(
            'header' => __('all', null),
            'actions' => true
        ),
        'extras' => $this->Structures->ajaxIndex('Customize/UserAnnouncements/index/all')
    );
    
    $displayNextForm = true;
    
    // CUSTOM CODE
    $hookLink = $this->Structures->hook('all');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    if ($displayNextForm)
        $this->Structures->build($finalAtimStructure, $finalOptions);
}