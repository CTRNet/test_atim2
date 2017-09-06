<?php

class ProtocolExtendControl extends ProtocolAppModel
{

    public $masterFormAlias = 'protocol_extend_masters';

    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}