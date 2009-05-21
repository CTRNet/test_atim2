<?php 
	
class SummariesHelper extends Helper {

	var $name = 'Summaries';
	var $helpers = array( 'Html', 'Translations', 'othAuth', 'Forms' );
	
	function build( $ctrapp_summary=array(), $lang=array(), $return_value=NULL ) {
		
		$return_text = '';
	
		$return_text .= '
			<h2>
				'.$this->Html->link( $this->Translations->t( 'core_menu_tools', $lang ), '/menus/tools/', array( 'id'=>'h2_tools_menu' ), NULL, false ).'
				'.$this->Html->link( $this->Translations->t( 'order_order management', $lang ), '/order/orders/index/', array( 'id'=>'h2_order_orders_index' ), NULL, false ).'
		';
		
		// display if array not blank
		if ( !empty($ctrapp_summary) ) {
				
					$form_type = 'summary';
					$form_model = $ctrapp_summary['text']['data'];
					$form_field = $ctrapp_summary['text']['form'];
					$form_link = array();
					$form_lang = $lang;
					
				$display_summary_text = $this->Forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang, NULL, NULL, ' ' );
				
					$form_type = 'summary';
					$form_model = $ctrapp_summary['desc']['data'];
					$form_field = $ctrapp_summary['desc']['form'];
					$form_link = array();
					$form_lang = $lang;
					
				$display_summary_desc = $this->Forms->build( $form_type, $form_model, $form_field, $form_link, $form_lang, NULL, NULL, ', ' );
				
				$return_text .= '
					<div id="h2_summary">
						'.$this->Html->link( $display_summary_text, '/order/orders/detail/'.$ctrapp_summary['text']['id'], NULL, NULL, false ).'
						'.$display_summary_desc.'
					</div>
				';
			
		} // END if count
		
		$return_text .= '
			</h2>
		';
		
		if ( $return_value ) {
			
			return $return_text;
			
		} else {
			echo $return_text;
		}
		
	} // end TABS function
	
}
		
?>
