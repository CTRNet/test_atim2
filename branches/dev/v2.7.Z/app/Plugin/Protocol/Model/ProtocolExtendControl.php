<?php

class ProtocolExtendControl extends ProtocolAppModel
{

    public $master_form_alias = 'protocol_extend_masters';

    function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}