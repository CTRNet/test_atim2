<?php
if (empty($this->request->data['Order']['order_number'])) {
    $result = $this->Order->find('first', array(
        'fields' => array(
            'Order.order_number'
        ),
        'conditions' => array(
            'Order.order_number REGEXP ' => date('Y') . '-[0-9]+$'
        ),
        'order' => array(
            'Order.order_number DESC'
        )
    ));
    
    $qcNdCodeSuffix = null;
    if ($result) {
        // increment it
        $qcNdCodeSuffix = substr($result['Order']['order_number'], 5) + 1;
    } else {
        // first of the year
        $qcNdCodeSuffix = 1;
    }
    $this->request->data['Order']['order_number'] = sprintf('%d-%03d', date('Y'), $qcNdCodeSuffix);
}