<?php
    $structureLinks['index'] = array(
        'edit' => '/ClinicalAnnotation/MiscIdentifiers/edit/' . $atimMenuVariables['Participant.id'] . '/%%MiscIdentifier.id%%/',
        'delete' => '/ClinicalAnnotation/MiscIdentifiers/delete/' . $atimMenuVariables['Participant.id'] . '/%%MiscIdentifier.id%%/'
    );
    
    $finalOptions = array(
        'links' => $structureLinks,
        'settings' => array(
            'header' => __('misc identifiers', null)
        )
    );

    if (AppController::checkLinkPermission('ClinicalAnnotation/MiscIdentifiers/listall/')) {
        $finalOptions['type'] = 'index';
        $finalOptions['data'] = $participantIdentifiersData;
        $finalAtimStructure = $atimStructureForMiscIdentifiers;
    } else {
        $finalAtimStructure = $emptyStructure;
        $finalOptions['type'] = 'detail';
        $finalOptions['data'] = array();
        $finalOptions['extras'] = '<div>' . __('You are not authorized to access that location.') . '</div>';
    }

    // CUSTOM CODE
    $hookLink = $this->Structures->hook('identifiers');
    if ($hookLink) {
        require ($hookLink);
    }
    
    // BUILD FORM
    $this->Structures->build($finalAtimStructure, $finalOptions);