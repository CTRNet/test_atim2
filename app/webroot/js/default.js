function checkAll( $div ) {
	
	// check compatibility
	if ( !document.getElementsByTagName ) return false;
	if ( !document.getElementById ) return false;
	
	// check existing IDs and attributes
	if ( !document.getElementById( $div ) ) return false;
	
	allInputs = document.getElementById( $div ).getElementsByTagName( 'input' );
	for ( var i=0; i<allInputs.length; i++ ) {
		if ( allInputs[i].getAttribute('type')=='checkbox' ) {
			// allInputs[i].setAttribute('checked', 'checked');
			allInputs[i].checked = true;
		}
		
	}
	
}

function uncheckAll( $div ) {
	
	// check compatibility
	if ( !document.getElementsByTagName ) return false;
	if ( !document.getElementById ) return false;
	
	// check existing IDs and attributes
	if ( !document.getElementById( $div ) ) return false;
	
	allInputs = document.getElementById( $div ).getElementsByTagName( 'input' );
	for ( var i=0; i<allInputs.length; i++ ) {
		if ( allInputs[i].getAttribute('type')=='checkbox' ) {
			allInputs[i].checked = false;
		}
		
	}
	
}
	
/*
	admin editors, expandable list of elements
	individual elements should be wrapped in p tags, and those p tags wrapped in a containing div
	fields (input, etc) should obviously have array names as they will be exact clones
*/

	function clone_fields(containing_div) {
		
		div = document.getElementById(containing_div); // div containing add artist selects/inputs
		ps = div.getElementsByTagName("p"); // ps is array of p tags in div
		
		new_p = ps[ps.length-1].cloneNode(true); // make copy of last p tag and all elements it contains
		
		div.appendChild(new_p); // append newly copied p tag inside div
		
	}
	
	function remove_fields(p) {
	
		a = p.parentNode; // a tag is parent of onclick attribute
		div = a.parentNode; // div is parent of a tag
		
		ps = div.getElementsByTagName("p"); // ps is array of p tags in div
		
		if ( ps.length>1 ) { // if more than one p tag in div...
			div.removeChild(a); // remove p tag that a tag is in
		} else {
			alert('Sorry, you cannot remove all of these field sets.'); // alert message
		}
		
	}
	
	function getJsonFromClass(cssClass){
		var startIndex = cssClass.indexOf("{");
		return eval ('(' + cssClass.substr(startIndex, cssClass.lastIndexOf("}") - startIndex + 1) + ')');
	}
	
	$(function(){
		//field highlighting
		if($("#table1row0").length == 1){
			//gridview
			$('form').highlight('td');
		}else{
			$('form').highlight('tr');
		}
		
		//tree view controls
		$(".reveal:not(.not_allowed)").each(function(){
			var json = getJsonFromClass($(this).attr("class"));
			$(this).toggle(function(){
				$("#tree_" + json.tree).stop(true, true);
				$("#tree_" + json.tree).show("blind", {}, 350);
			}, function(){
				$("#tree_" + json.tree).stop(true, true);
				$("#tree_" + json.tree).hide("blind", {}, 350);
			});
		});
		
		//ajax controls
		//evals the json within the class of the element and calls the method defined in callback
		//the callback method needs to take this and json as parameters
		$(".ajax").click(function(){
			var json = getJsonFromClass($(this).attr("class"));
			var fct = eval("(" + json.callback + ")");
			fct.apply(this, [this, json]);
			return false;
		});
		
		//autocomplete controls
		$(".jqueryAutocomplete").each(function(){
			var json = getJsonFromClass($(this).attr("class"));
			var fct = eval("(" + json.callback + ")");
			fct.apply(this, [this, json]);
			return false;
		});
		
		//calendar controls
		$.datepicker.setDefaults($.datepicker.regional[locale]);
		$(".datepicker").each(function(){
			initDatepicker(this);
			$(this).click(function(){
				//bug fix for Safari and Chrome
				$(this).datepicker('show');
			});
		});
		//datepicker style
		$("#ui-datepicker-div").addClass("jquery_cupertino");
		//autocomplete style
		$(".ui-autocomplete").addClass("jquery_cupertino");
	});

	function initDatepicker(element){
		var tmpId = element.id.substr(0, element.id.length - 7);
		if($('#' + tmpId).val().length > 0 && $('#' + tmpId + "-mm").val().length > 0 && $('#' + tmpId + "-dd").val().length > 0){
			//set the current field date into the datepicker
			$(element).data('val', $('#' + tmpId).val() + "-" + $('#' + tmpId + "-mm").val() + "-" + $('#' + tmpId + "-dd").val());
		}
		$(element).datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'yy-mm-dd',
			maxDate: '2100-12-31',
			yearRange: '-100:+10',
			firstDay: 0,
			beforeShow: function(input, inst){
				//put the date back in place
				//because of datagrids copy controls we cannot keep the date in tmp
				var tmpDate = $('#' + tmpId).val() + "-" + $('#' + tmpId + "-mm").val() + "-" + $('#' + tmpId + "-dd").val();
				if(tmpDate.length == 10){
					$(this).datepicker('setDate', tmpDate);
				}
				//show fake button to hide real button value
				var item = $(this).parent().children("img")[0];
				$(item).css("z-index", "1");
			},
			onClose: function(dateText,picker) {
				//hide the date
				$(this).val(" ");//space required for Safari and Chome or the button disappears
				var dateSplit = dateText.split(/-/);
				$('#' + tmpId).val(dateSplit[0]); 
	        	$('#' + tmpId + "-mm").val(dateSplit[1]);
	        	$('#' + tmpId + "-dd").val(dateSplit[2]);
	        	//hide fake button
	        	var item = $(this).parent().children("img")[0];
				$(item).css("z-index", "-1");
		    }
		});
		
		//activate fake_datepicker in case there is a problem with z-index
		$(element).parent().children("img").click(function(){
			$(element).datepicker('show');
		});
	}
	
	function autoComplete(element, json){
		alert(root_url + "/" + $(element).attr("url"));
		$(element).autocomplete({
			source: root_url + "/" + $(element).attr("url")
		});
	}