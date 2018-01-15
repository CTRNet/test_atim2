<?php
if ($messageType == 'all') {
    
    // Main form
    
    // --------- Summary ----------------------------------------------------------------------------------------------
    
    $finalAtimStructure = array();
    $finalOptions = array(
        'type' => 'detail',
        'links' => array(),
        'settings' => array(
            'actions' => false
        )
    );
    $this->Structures->build($atimStructure, $finalOptions);
    
    // --------- Profile & Reproductive History ----------------------------------------------------------------------------------------------
    
    $finalAtimStructure = array();
    $finalOptions = array(
        'type' => 'detail',
        'links' => array(),
        'settings' => array(
            'header' => __('main messages', null),
            'actions' => false
        ),
        'extras' => $this->Structures->ajaxIndex('Administrate/SardoMigrations/listAll/main')
    );
    $this->Structures->build($finalAtimStructure, $finalOptions);
    
    // --------- Empty lists ----------------------------------------------------------------------------------------------
    
    $structureLinks = array(
        'bottom' => array(
            'export as CSV file (comma-separated values)' => sprintf("javascript:setCsvPopup('Administrate/SardoMigrations/listAll/csv/');", 0)
        )
    );
    
    $finalAtimStructure = array();
    $finalOptions = array(
        'type' => 'detail',
        'links' => $structureLinks,
        'settings' => array(
            'header' => __('profile and reproductive history update', null),
            'actions' => true
        ),
        'extras' => $this->Structures->ajaxIndex('Administrate/SardoMigrations/listAll/profile_reproductive')
    );
    $this->Structures->build($finalAtimStructure, $finalOptions);
} elseif ($messageType == 'csv') {
    
    $this->Structures->build($atimStructureMessages, array(
        'type' => 'csv',
        'data' => $this->request->data,
        'settings' => array(
            'all_fields' => true
        )
    ));
    exit();
} else {
    
    // Messages Display (sub-form)
    
    $finalOptions = array(
        'type' => 'index',
        'settings' => array(
            'pagination' => true,
            'actions' => false
        ),
        'override' => array()
    );
    $this->Structures->build($atimStructureMessages, $finalOptions);
}