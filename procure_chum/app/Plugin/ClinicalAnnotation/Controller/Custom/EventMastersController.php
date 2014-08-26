<?php

class EventMastersControllerCustom extends EventMastersController {
	
	var $paginate = array('EventMaster'=>array('limit' => pagination_amount,'order'=>'EventMaster.event_date ASC, EventMaster.procure_form_identification ASC'));

}

?>