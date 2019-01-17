<?php

/**
 * Class ProtocolExtendControl
 */
class ProtocolExtendControl extends ProtocolAppModel
{

    public $masterFormAlias = 'protocol_extend_masters';

    /**
     *
     * @param mixed $results
     * @param bool $primary
     * @return mixed
     */
    public function afterFind($results, $primary = false)
    {
        return $this->applyMasterFormAlias($results, $primary);
    }
}