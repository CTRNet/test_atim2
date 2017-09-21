<?php
$this->set('display_edit_button', in_array($this->request->data['EventControl']['event_type'], $this->EventControl->modifiable_event_types));
