// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .



var ready = function() {
	$('#new-task').click(function (event) {
		$.get( "/tasks/new", function( data ) {
			$( "li.new.task" ).html( data );
		});
  		event.preventDefault(); // Prevent link from following its href
	});
	
	$('.new-child').click(function(event) {
		var parent_id = this.className.match(/parent-id-([0-9]+)$/)[1];
		$.get( "/tasks/new?parent_id="+parent_id, function( data ) {
			$( "li#new-child-"+parent_id ).html( data );
		});
		event.preventDefault(); // Prevent link from following its href
	});
}

var submitForm = function(id) {
	$.ajax({url : "/tasks", 
			type : "POST",
			data : $( "#new_task" ).serialize(), 
			complete : function( response, status ) {
				$("li#"+id+" > ul").append( response.responseText );
				$("li#new-child-"+id ).html('<a class="new-child parent-id-'+id+'" href="/tasks/new?parent_id='+id+'">New Child</a>');
				ready();
			}
	});
	event.preventDefault();
}

var cancelForm = function(id) {
	$("li#new-child-"+id ).html('<a class="new-child parent-id-'+id+'" href="/tasks/new?parent_id='+id+'">New Child</a>');
	ready();
	event.preventDefault();
}


$(document).ready(ready);
$(document).on('page:load', ready);

