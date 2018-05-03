<?php
if (in_array($listType, array(
    'all',
    'current'
))) {
    
    $structureLinks = array(
        'index' => array(
            'detail' => '/Customize/Announcements/detail/%%Announcement.id%%'
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
        'extras' => $this->Structures->ajaxIndex('Customize/Announcements/index/current')
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
        'extras' => $this->Structures->ajaxIndex('Customize/Announcements/index/all')
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