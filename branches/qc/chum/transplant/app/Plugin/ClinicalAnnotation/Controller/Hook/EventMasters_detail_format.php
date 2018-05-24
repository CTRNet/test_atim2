<?php
$this->set('displayEditButton', in_array($this->request->data['EventControl']['event_type'], $this->EventControl->modifiableEventTypes));