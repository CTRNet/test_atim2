<?php
$this->Structures->build($atimStructure, array(
    'settings' => array(
        'pagination' => true
    ),
    'links' => array(
        'index' => array(
            'detail' => '/Tools/CollectionProtocol/detail/%%CollectionProtocol.id%%',
            'edit' => '/Tools/CollectionProtocol/edit/%%CollectionProtocol.id%%',
            'delete' => '/Tools/CollectionProtocol/delete/%%CollectionProtocol.id%%'
        )
    )
));